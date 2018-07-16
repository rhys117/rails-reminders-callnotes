class RemindersController < ApplicationController
  before_action :logged_in_user, only: [:index, :complete]
  before_action :correct_user,   unless: -> { session[:user_id].nil? }

  def home
    if logged_in?
      @current_reminders = current_user.reminders.ordered_priority.where('date <= ? AND complete= ?', Date.current, 'f')
      @reminder = Reminder.new
      @quick_notes = current_user.quick_notes.all
    end
  end

  def index
    if params[:search]
      @current_reminders = current_reminders.search(params[:search].strip).ordered_date_completed_priority
      @future_reminders = future_reminders.search(params[:search].strip).ordered_date_completed_priority
    else
      @current_reminders = current_reminders.ordered_date_completed_priority
      @future_reminders = future_reminders.ordered_date_completed_priority
    end
  end

  def new
    @reminder = Reminder.new
  end

  def create
    @reminder = current_user.reminders.build(reminder_params)
    if @reminder.save
      flash[:success] = "Reminder created #{@reminder.reference}"
      session[:rt_copy] = rt_note(@reminder)
      session[:rt_date] = @reminder.date
      redirect_back(fallback_location: root_path)
    else
      render 'new'
    end
  end

  def mark_complete
    reminder = Reminder.find(params[:id])
    reminder.complete = true
    reminder.save
    flash[:success] = "Reminder marked complete #{reminder.reference}" if reminder.complete
    redirect_back(fallback_location: root_path)
  end

  def mark_incomplete
    reminder = Reminder.find(params[:id])
    reminder.complete = false
    reminder.save
    flash[:warning] = "Reminder marked incomplete #{reminder.reference}" unless reminder.complete
    redirect_back(fallback_location: root_path)
  end

  def edit
    @reminder = current_user.reminders.find(params[:id])
  end

  def update
    if current_user.reminders.find(params[:id]).update_attributes(reminder_params)
      reminder = current_user.reminders.find(params[:id])
      flash[:success] = "Reminder updated #{reminder.reference}"
      session[:rt_copy] = rt_note(reminder)
      session[:rt_date] = reminder.date
      redirect_to(root_url)
    else
      @reminder = current_user.reminders.build(reminder_params)
      @reminder.save
      flash[:danger] = @reminder.errors.full_messages.to_sentence
      redirect_to(edit_reminder_path(params[:id]))
    end
  end

  def destroy
    if current_user.reminders.find(params[:id]).destroy
      flash[:warning] = "Reminder deleted"
      redirect_back(fallback_location: root_path)
    else
      flash[:error] = "Whoops! Something went wrong"
      redirect_back(fallback_location: root_path)
    end
  end

  def auto_manage
    @auto_manage = auto_manage_hash
  end

  private

  def auto_manage_hash
    output = {}
    output['two_days'] = current_reminders.select('reference').where('check_for LIKE ? AND complete = ?',
                                                                     '2DayWarning', false)
    output['check_contact'] = current_reminders.select('reference').where('check_for LIKE ? AND complete = ?',
                                                                          'customer contact', false)
    output
  end

  def current_reminders
    current_user.reminders.ordered_priority.where('date <= ?', Date.current)
  end

  def future_reminders
    current_user.reminders.where('date > ?', Date.current).ordered_date_completed_priority
  end

  # Before actions
  def correct_user
    @user = User.find(session[:user_id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def reminder_params
    params.require(:reminder).permit(:reference, :vocus_ticket, :nbn_search, :select_date,
                                     :date, :vocus, :service_type, :notes, :priority,
                                     :fault_type, :check_for, :search, :filter_out)
  end

  def rt_note(reminder)
    combined = ""
    combined << "#{reminder.fault_type.upcase} | " unless reminder.fault_type.nil?
    combined << "#{reminder.notes} " unless reminder.notes.nil?
    combined << "#{reminder.check_for}?" unless reminder.check_for.nil?
    combined
    "#{reminder.service_type} #{combined}"
  end
end

class RemindersController < ApplicationController
  # before_action :logged_in_user, only: [:index, :complete]
  before_action :correct_user

  def index
    @reminders = if params[:search]
      current_user.reminders.search(params[:search]).ordered_date_completed_priority.paginate(page: params[:page], per_page: 35)
    else
      current_user.reminders.ordered_date_completed_priority.paginate(page: params[:page], per_page: 35)
    end
  end

  def new
    @reminder = Reminder.new
  end

  def create
    @reminder = current_user.reminders.build(reminder_params)
    if @reminder.save
      flash[:success] = "Reminder created"
      session[:rt_copy] = rt_note(@reminder)
      session[:rt_date] = @reminder.date
      redirect_back(fallback_location: root_path)
    else
      render 'new'
    end
  end

  def inverse_complete
    reminder = Reminder.find(params[:id])
    reminder.complete = !reminder.complete
    reminder.save
    flash[:success] = "Reminder marked complete" if reminder.complete
    flash[:warning] = "Reminder marked incomplete" if !reminder.complete
    redirect_back(fallback_location: root_path)
  end

  def edit
    @reminder = current_user.reminders.find(params[:id])
  end

  def update
    if @reminder = current_user.reminders.find(params[:id]).update_attributes(reminder_params)
      flash[:success] = "Reminder updated"
      redirect_to(root_path)
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

  private

    # Before actions
    def correct_user
      @user = User.find(session[:user_id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def reminder_params
      params.require(:reminder).permit(:reference, :vocus_ticket, :nbn_search, :select_date,
                                       :date, :vocus, :service_type, :notes, :priority,
                                       :fault_type, :check_for, :search)
    end

    def rt_note(reminder)
      combined = ""
      combined << "#{reminder.fault_type.upcase} | " unless reminder.fault_type.nil?
      combined << "#{reminder.notes} " unless reminder.notes.nil?
      combined << "#{reminder.check_for}?" unless reminder.check_for.nil?
      combined
      "#{@reminder.service_type} #{combined}"
    end
end

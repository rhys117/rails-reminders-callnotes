class CallNotesController < ApplicationController
  before_action :set_call_note, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user

  def index
    redirect_to new_call_note_path
  end

  def correspondence_categories
    respond_to { |format| format.js }
  end

  def template_categories
    respond_to { |format| format.js }
  end

  def selected_template
    params[:cat_id] = 'general' if params[:cat_id].length < 1
    templates = YAML.load_file("#{::Rails.root}/app/assets/templates/#{params[:cat_id].downcase}/#{params[:type]}.yml")
    @selected = templates[params[:template]]
    respond_to do |format|
      format.js
    end
  end

  # GET /call_notes/new
  def new
    @call_note = CallNote.new
  end

  def create
    @reminder = Reminder.new
  end

  def version_two

  end
  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def call_note_params
    params.require(:call_note).permit(:time, :name, :call_type, :phone_number, :call_answer,
                                      :id_check, :enquiry_notes, :call_conclusion, :conclusion_condition,
                                      :conclusion_agreed_contact, :conclusion_contact_date,
                                      :conclusion_best_contact, :work_notes, :correspondence_notes)
  end
end


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
    params[:cat_id] = 'general' if params[:cat_id].empty?
    templates = YAML.load_file("#{::Rails.root}/app/assets/templates/#{params[:cat_id].downcase}/#{params[:type]}.yml")
    @selected = templates[params[:template]]
    respond_to do |format|
      format.js
    end
  end

  def new
    @call_note = CallNote.new
  end

  def create
    @reminder = Reminder.new
  end

  # Work in progress v2 (generate forms off of json >> will then move to form creator and db)
  def version_two
    @call_note = CallNote.new
  end

  private

  def call_note_params
    params.require(:call_note).permit(:time, :name, :call_type, :phone_number, :call_answer,
                                      :id_check, :not_onsite, :enquiry_notes, :call_conclusion, :conclusion_condition,
                                      :conclusion_agreed_contact, :conclusion_contact_date,
                                      :conclusion_best_contact, :work_notes, :correspondence_notes)
  end
end


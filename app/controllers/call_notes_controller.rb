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
    @enquiry_notes = ''
    @work_notes = params[:call_note][:work_notes]
    @email_notes = params[:call_note][:email_notes].strip

    notes_params_pairs = notes_params_pairs(params)
    custom_input = {}
    params[:call_note].each do |param, enquiry_notes|
      if param.to_s.include?('enquiry_notes') && enquiry_notes.length > 0
        custom_input[param.to_sym] = "#{enquiry_notes.strip} \n"
      end
    end

    params[:call_note].each do |key, value|
      unless value.empty?
        if custom_input.has_key?(key.to_sym)
          @enquiry_notes << custom_input[key.to_sym] + "\n"
        elsif notes_params_pairs.has_key?(key.to_sym)
          @enquiry_notes << notes_params_pairs[key.to_sym][value] + "\n"
        end
      end
    end
    @enquiry_notes.strip!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_call_note
    @call_note = CallNote.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def call_note_params
    params.require(:call_note).permit(:time, :name, :call_type, :phone_number, :call_answer,
                                      :id_check, :enquiry_notes, :call_conclusion, :conclusion_condition,
                                      :conclusion_agreed_contact, :conclusion_contact_date,
                                      :conclusion_best_contact, :work_notes, :correspondence_notes)
  end

  def notes_params_pairs(params)
    call_answer_pairs = {
        'spoke_to' => 'spoke to',
        'left_vm' => 'left VM',
        'rang_out' => 'rang out with no option for VM'
    }
    call_answer = call_answer_pairs[params[:call_note]['call_answer']]

    conclusion_call_update_pairs = {
        'next_update' => "next update",
        'date' => "#{params[:call_note]['conclusion_contact_date']}"
    }
    conclusion_call_update = conclusion_call_update_pairs[params[:call_note]['conclusion_agreed_contact']]
    {
      :call_type => {
        'live_call' => "Live call from #{params[:call_note]['phone_number']} >> #{call_answer} #{params[:call_note]['name']}",
        'call_for' => "Outbound call for #{params[:call_note]['phone_number']} >> #{call_answer} #{params[:call_note]['name']}",
        'callback' => "Callback for #{params[:call_note]['phone_number']} >> #{call_answer} #{params[:call_note]['name']}"
      },
      :id_check => {
        'confirmed_id' => "- confirmed ID \n",
        'confirmed_id_tech' => "- confirmed ID as technical advocate \n",
        'confirmed_id_auth' => "- confirmed ID as authorised representative \n",
        'not_on_account' => "- caller not on account \n"
      },
      :call_conclusion => {
        "advised_work" => "Advised expected timeframe for #{params[:call_note]['conclusion_condition']} and agreed to contact on #{conclusion_call_update} \n- best contact is: #{params[:call_note]['conclusion_best_contact']}",
        "customer_will_contact" => "Customer will contact support when #{params[:call_note]['conclusion_condition']}",
        "customer_will_monitor" => "Customer will monitor for further issues",
        "no_further_query" => "No further query"
      }
    }
  end
end


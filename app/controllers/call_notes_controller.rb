class CallNotesController < ApplicationController
  before_action :set_call_note, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user

  # GET /call_notes
  # GET /call_notes.json
  def index
    @enquiry_notes = ""
    @work_notes = params[:call_note][:work_notes]

    notes_params_pairs = notes_params_pairs(params)
    custom_input = {}
    params[:call_note].each do |param, additional_notes|
      if param.to_s.include?('additional') && additional_notes.length > 0
        custom_input[param.to_sym] = "#{additional_notes} \n"
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
  end

  # GET /call_notes/1
  # GET /call_notes/1.json
  def show
  end

  def from_category
    file = YAML.load_file("#{::Rails.root}/lib/assets/call_notes_quick_add.yml")
    @selected = file[params[:cat_id]]
    respond_to do |format|
      format.js
    end
  end

  # GET /call_notes/new
  def new
    # @work_questions = YAML.load_file("#{::Rails.root}/lib/note_templates/lts/offline.yml")
    @items = {}
    @quick_add_groups = YAML.load_file("#{::Rails.root}/lib/assets/call_notes_quick_add.yml").keys
    @call_note = CallNote.new
  end

  # GET /call_notes/1/edit
  def edit
  end

  # POST /call_notes
  # POST /call_notes.json
  def create
    # @call_note = CallNote.new(call_note_params)

    # respond_to do |format|
    #   if @call_note.save
    #     format.html { redirect_to @call_note, notice: 'Call note was successfully created.' }
    #     format.json { render :show, status: :created, location: @call_note }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @call_note.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /call_notes/1
  # PATCH/PUT /call_notes/1.json
  def update
    respond_to do |format|
      if @call_note.update(call_note_params)
        format.html { redirect_to @call_note, notice: 'Call note was successfully updated.' }
        format.json { render :show, status: :ok, location: @call_note }
      else
        format.html { render :edit }
        format.json { render json: @call_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /call_notes/1
  # DELETE /call_notes/1.json
  def destroy
    @call_note.destroy
    respond_to do |format|
      format.html { redirect_to call_notes_url, notice: 'Call note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_call_note
      @call_note = CallNote.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def call_note_params
      params.require(:call_note).permit(:time, :name, :call_type, :phone_number, :call_answer,
                                        :id_check, :additional_notes, :call_conclusion, :conclusion_condition,
                                        :conclusion_agreed_contact, :conclusion_contact_date,
                                        :conclusion_best_contact, :work_notes)
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


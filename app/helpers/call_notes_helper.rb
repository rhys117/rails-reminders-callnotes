module CallNotesHelper
  def select_options
    select = {}
    select[:call_type] = { 'Incoming live call' => 'live_call', 'Outgoing call' => 'call_for',
                            'Outgoing callback request' => 'callback' }
    select[:call_answer] = { 'Spoke to' => 'spoke_to', 'Left VM' => 'left_vm', 'Rang Out. No VM' => 'rang_out' }
    select[:id_check] = { 'Confirmed ID' => 'confirmed_id', 'Confirmed as technical advocate' => 'confirmed_id_tech' ,
                          'Confirmed as authorised representative' => 'confirmed_id_auth',
                          'Caller not on account' => 'not_on_account' }
    select[:call_conclusion] = { 'No further query' => 'no_further_query',
                                 'Customer will monitor for further issues' => 'customer_will_monitor',
                                 'Customer will contact support' => 'customer_will_contact',
                                 'Advised customer of work' => 'advised_work' }
    select
  end

  def template_categories
    Dir.entries("#{::Rails.root}/app/assets/templates").reject { |dir| dir.include?('.') }.map(&:upcase).sort
  end

  def template_category_options(category)
    category = 'GENERAL' if category.nil?
    path = "#{::Rails.root}/app/assets/templates/#{category.downcase}"
    options = {}
    options[:enquiry] = File.exists?("#{path}/enquiry.yml") ? YAML.load_file("#{path}/enquiry.yml") : []
    options[:work] = File.exists?("#{path}/work.yml") ? YAML.load_file("#{path}/work.yml") : []
    options
  end

  def correspondence_categories
    Dir["#{::Rails.root}/app/assets/correspondence/*"].map { |f| File.basename(f, ".*").upcase }.sort
  end

  def correspondence_options(category)
    category = 'GENERAL' if category.nil?
    path = "#{::Rails.root}/app/assets/correspondence"
    options = if File.exists?("#{path}/#{category.downcase}.yml")
                YAML.load_file("#{path}/#{category.downcase}.yml")
              else
                {}
              end
    # replace agent with current users name
    options.each { |_, message| message.gsub!('{AGENT}', current_user.name) }
  end

  def active_class?(param, match_phrase)
    param = 'GENERAL' if param.nil?
    true if param == match_phrase
  end

  def array_to_select_options(array)
    options_hash = {}
    array.each do |option|
      options_hash[option] = option
    end
  end

  def ping_test
    <<~EOS
      Packets: Sent = 100, Received = n Lost = n (n% loss),
      Approximate round trip times in milliseconds:
      Minimum = 0ms, Maximum = 0ms, Average = 0ms
    EOS
  end

  def speed_tests
    <<~EOS
      Day 1(date)  Morning:    Afternoon:    Evening:
      Day 2(date)  Morning:    Afternoon:    Evening:
      Day 3(date)  Morning:    Afternoon:    Evening:
      (3 days of testing is not required, but this is the format we'd like you to use to present your results, you can include more tests to show the issue)
    EOS
  end

  def answers_order(answers)
    # Ensures colour of light comes first
    answers.map! do |answer|
      split_answer = answer.downcase.split(' ')
      split_answer.rotate! if (split_answer[0] == 'flashing') || (split_answer[0] == 'solid')
      split_answer.join(' ').titleize
    end

    sort_order = %w(green blue yellow amber orange white red off yes no)
    answers.sort_by do |answer|
      answer.split(' ').map do |word|
        sort_order.include?(word.downcase) ? sort_order.index(word.downcase) : -1
      end
    end
  end

  QUESTIONS_PER_LINE = 3.freeze
  def form_lines(questions_and_answers)
    result = []
    current_subset = []
    questions_and_answers.each do |hash_data|
      if hash_data[:input_type] == 'formatting' || hash_data[:input_type] == 'components'
          result << current_subset unless current_subset.empty?
        result << [hash_data]
        current_subset = []
      else
        current_subset << hash_data
        if current_subset.length == QUESTIONS_PER_LINE
          result << current_subset
          current_subset = []
        end
      end
    end
    result << current_subset
    result
  end

  def answer_input_type(question, split_answers)
    if split_answers.length == 2
      'radio'
    elsif split_answers.length > 2
      'select'
    elsif question.downcase.include?('description')
      'textarea'
    elsif split_answers.empty?
      'text'
    elsif split_answers[0].downcase.include?('textarea')
      'textarea'
    elsif split_answers[0].downcase == 'pingtest'
      'pingtest'
    elsif split_answers[0].downcase == 'speedtests'
      'speedtests'
    else
      'text'
    end
  end

  def parse_template(template)
    template.gsub!(/[\[\]]/, '')

    questions_and_answers = []
    seen_questions = []

    current_heading = nil
    template.each_line do |line|
      line_result = {}

      # if not identified as question include line as formatting
      unless line.include?(':')
        line.strip!
        # search for component indicators from template
        components = line.match(/(?<={)[^}]*/)
        if components
          split_components = components.to_s.split(',').map(&:strip)
          split_components.map! { |str| "COMPONENT - #{str}" }
          line_result[:input_type] = 'components'
          line_result[:answers] = split_components
        else
          line_result[:question] = line
          line_result[:input_type] = 'formatting'
        end
        line_result[:haeding] = nil
        current_heading = line
        questions_and_answers << line_result
        next
      end

      # split line into question and answers and sort split answers
      next if line.nil?
      question, answer = line.split(':')
      answer ||= ''
      split_answers = answers_order(answer.split('/'))

      # delete blank space in answers
      split_answers.map!(&:strip)
      split_answers.delete('')

      # set question heading - used to correctly identify line with javascript when multiple instances of same line
      unless question[0] == '-' || question[0] == '>'
        current_heading = question
      end

      # if duplicate question include in template as error formatting line
      if seen_questions.include?(question)
        logger.call_notes.debug({ template: template, question: question })
        line_result[:question] = "Error: Duplicate question - #{question}"
        line_result[:input_type] = 'formatting'
        line_result[:answers] = split_answers
      else
        line_result[:question] =  question
        line_result[:input_type] = answer_input_type(question, split_answers)
        line_result[:answers] = split_answers
      end
      line_result[:heading] = current_heading
      seen_questions << "#{current_heading}: #{question}"
      questions_and_answers << line_result
    end

    form_lines(questions_and_answers)
  end

  def enquiry_params_pairs(params)
    call_answer_pairs = {
        'spoke_to' => 'spoke to',
        'left_vm' => 'left VM',
        'rang_out' => 'rang out with no option for VM'
    }
    call_answer = call_answer_pairs[params[:call_note]['call_answer']]

    conclusion_call_update_pairs = {
        'next_update' => 'next update',
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
        'advised_work' => "Advised expected timeframe for #{params[:call_note]['conclusion_condition']} and agreed to contact on #{conclusion_call_update} \n- best contact is: #{params[:call_note]['conclusion_best_contact']}",
        'customer_will_contact' => "Customer will contact support #{params[:call_note]['conclusion_condition']}",
        'customer_will_monitor' => "Customer will monitor for further issues",
        'no_further_query' => "No further query"
      }
    }
  end

  def generated_enquiry_notes(params)
    enquiry_notes = ''
    notes_params_pairs = enquiry_params_pairs(params)
    custom_input = {}
    params[:call_note].each do |param, enquiry_notes|
      if param.to_s.include?('enquiry_notes') && enquiry_notes.length > 0
        custom_input[param.to_sym] = "#{enquiry_notes.strip} \n"
      end
    end

    params[:call_note].each do |key, value|
      unless value.empty?
        if custom_input.has_key?(key.to_sym)
          enquiry_notes << custom_input[key.to_sym] + "\n"
        elsif notes_params_pairs.has_key?(key.to_sym)
          enquiry_notes << notes_params_pairs[key.to_sym][value] + "\n"
        end
      end
    end
    enquiry_notes.strip
  end

  def component_link(title)
    title.gsub('COMPONENT - ', '').strip
  end

  def can_delete_question?(input_type, question)
    !((input_type == 'formatting' && question.length < 1) || input_type == 'components' ||
        question[0..5] == 'Note -')
  end

  def load_template(category, selection)
    path = "#{::Rails.root}/app/assets/templates_v2"
    YAML.load_file("#{path}/#{category}.yml")[selection]
  end

  def process_template(template)
    lines = []
    current_line = []
    width = 12 # matches bootstrap 12 grid

    #
    results = []
    template['questions'].each do |options|
      results << options
      if options['subsections']

      end
    end
    #

    template['questions'].each do |options|
      width -= options['size'].to_i
      if width <= 0
        lines << current_line
        current_line = []
        width = 12
      end
      current_line << options
    end
    lines << current_line  unless current_line.empty?
    lines
  end

  def template_form_groups(category, selection)
    template = load_template(category, selection)

    process_template(template)
  end
end

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
    if File.exists?("#{path}/#{category.downcase}.yml")
      YAML.load_file("#{path}/#{category.downcase}.yml")
    else
      []
    end
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

    sort_order = ['green', 'blue', 'yellow', 'amber', 'orange', 'white', 'red', 'off', 'yes', 'no']
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
      if hash_data[:input_type] == 'formatting'
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
    return 'text' if split_answers.empty?
    if split_answers.length == 2
      'radio'
    elsif split_answers.length > 2
      'select'
    elsif question.downcase.include?('description') || split_answers[0].downcase.include?('textarea')
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

    template.each_line do |line|
      line_result = {}

      # if not identified as question include line as formatting
      unless line.include?(':')
        line.strip!
        if line.length > 0
          line_result[:question] = line
          line_result[:input_type] = 'formatting'
          questions_and_answers << line_result
        end
        next
      end

      # split line into question and answers and sort split answers
      question, answer = line.split(':')
      split_answers = answers_order(answer.split('/'))

      # delete blank space in answers
      split_answers.map!(&:strip)
      split_answers.delete('')

      # if duplicate question include in template as error formatting line
      if seen_questions.include?(question)
        line_result[:question] = "Error: Duplicate question - #{question}"
        line_result[:input_type] = 'formatting'
        line_result[:answers] = split_answers
        next
      end

      line_result[:question] =  question
      line_result[:input_type] = answer_input_type(question, split_answers)
      line_result[:answers] = split_answers
      questions_and_answers << line_result
    end

    form_lines(questions_and_answers)
  end
end

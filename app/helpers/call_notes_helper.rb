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

  def template_groups
    folder_names = %w(correspondence work enquiry)
    groups = {}
    folder_names.each do |folder|
      directory = "#{::Rails.root}/lib/generator_templates/#{folder}/*"
      groups[folder.to_sym] = Dir[directory].map { |f| File.basename(f, ".*").upcase }.sort
    end
    groups
  end

  def template_items
    template_items = {}
    template_items[:enquiry] = YAML.load_file("#{::Rails.root}/lib/generator_templates/enquiry/general.yml")
    template_items[:work] = YAML.load_file("#{::Rails.root}/lib/generator_templates/work/general.yml")
    template_items[:correspondence] = YAML.load_file("#{::Rails.root}/lib/generator_templates/correspondence/general.yml")
    template_items
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

  def sort_for_lights(answers)
    answers.map! do |answer|
      split_answer = answer.downcase.split(' ')
      if (split_answer[0] == 'flashing') || (split_answer[0] == 'solid')
        split_answer.rotate!
      end
      answer = split_answer.join(' ').titleize
    end

    sort_order = ['green', 'blue', 'yellow', 'amber', 'orange', 'white', 'red', 'off', 'yes', 'no']
    answers.sort_by do |answer|
      answer.split(' ').map do |word|
        if sort_order.include?(word.downcase)
          sort_order.index(word.downcase)
        else
          - 1
        end
      end
    end
  end

  def parse_template(template)
    template.gsub!(/[\[\]]/, '')

    questions_and_answers = {}

    template.each_line do |line|
      question, answer = line.split(':')
      unless answer.nil?
        split_answers = answer.split('/')
        split_answers = sort_for_lights(split_answers)

        split_answers.map!(&:strip)
        split_answers.delete('')

        unless questions_and_answers[question].nil?
          questions_and_answers["Error: Duplicate question in template #{question}. Please report me to Rhys."] = ['formatting']
        end

        if split_answers.length == 2
            questions_and_answers[question.strip] = ['radio', split_answers]
        elsif split_answers.length > 1
          questions_and_answers[question.strip] = ['select', split_answers]
        elsif
          if question.downcase.include?('description') || answer.downcase.include?('textarea')
            questions_and_answers[question.strip] = ['textarea']
          elsif answer.downcase.include?('pingtest')
            questions_and_answers[question.strip] = ['ping']
          elsif answer.downcase.include?('speedtests')
            questions_and_answers[question.strip] = ['speedtests']
          else
            questions_and_answers[question.strip] = ['text']
          end
        end
      else
        question.strip!
        if question.length > 0
          questions_and_answers[question] = ['formatting']
        end
      end
    end
    questions_and_answers
  end
end

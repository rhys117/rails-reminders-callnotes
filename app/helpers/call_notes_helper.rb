module CallNotesHelper
  def select_hash(answers)
    select_hash = {}
    answers.each do |answer|
      select_hash[answer] = answer
    end
    select_hash
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

        if split_answers.length > 1
          questions_and_answers[question.strip] = ['select', split_answers.map(&:strip)]
        else
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

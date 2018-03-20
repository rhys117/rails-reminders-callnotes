template = <<~EOS
           Customer calling to report service is offline with no sync

           Modem model and make:
           - SkyMesh Supplied: Yes/No
           - Confirmed FTTN compatible: Yes/No

           Modem Lights
           - DSL Sync: Off/Negotiating/Sync
           - Internet: Off/Green Flashing/Green Solid/Red

           Confirmed following troubleshooting
           - no INC or CRQ listed against PRI: yes/no
           - using main TO: yes/no
           - no filter/splitter: yes/no
           - restarted CPE: yes/no
           - router has been configured: yes/no
           - tested with alternate phone cable: yes/no

           LST
           - code:
           - status:
           - service stability:
           - CPE type detected:
           - Physical profile:

           Port Reset
           - code:
           - result: passed/failed

           SELT with CPE
           - code:
           - impairments: textarea

           SELT without CPE
           - code:
           - impairments: textarea

           Test result indications
           Bridgetap or other line impairment: yes/no
           - if yes, description: textarea

           CPE configuration/compatibility issue: yes/no
           - if yes has 2nd CPE been tested: yes/no
           -- Details of both CPE (MAC and models) tested if yes: textarea

           Gathered work ticket info: yes/no
           EOS

template.gsub!(/[\[\]]/, '')

questions_and_answers = Hash.new({ text: nil })

template.each_line do |line|
  question, answer = line.split(':')

  unless answer.nil?
    split_answers = answer.split('/')
    #split_answers = sort_for_lights(split_answers)

    #split_answers.map!(&:strip)
    #split_answers.delete('')
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

p questions_and_answers

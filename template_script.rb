template = 
"Fault Description (summary):

---------------------------
Tested NTD in a different power outlet: [Yes/No]
If unable, have you confirmed the outlet they're using works with another device?: [Yes/No]
Disconnected Battery Backup unit from NTD, did BBU light up?: [Yes/No]
Did any other equipment in the property die at the same time?: [Yes/No]

-- Customer Availability --
If NBN were to organise a service call in the next week, what day would be best between Monday and Friday?:
Mornings or Afternoons?:
What is the best contact phone number for us to pass on to NBN?
Name of the person who will be on site:
What is the best way for SkyMesh get customer updates?: sms / phone / email 
Provide + email/phone number: "

template.gsub!(/[\[\]]/, '')

questions_and_answers = Hash.new({ text: nil })

template.each_line do |line|
  question, answer = line.split(':')
  if !answer.nil?
    split_answers = answer.split('/')
    if split_answers.length > 1
      questions_and_answers[question.strip] = ['select', split_answers.map(&:strip)]
    else
      if question.downcase.include?('description')
        questions_and_answers[question.strip] = ['textarea']
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
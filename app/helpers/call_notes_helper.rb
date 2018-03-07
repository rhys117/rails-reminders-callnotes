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
end

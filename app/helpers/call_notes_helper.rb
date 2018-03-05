module CallNotesHelper
  def select_hash(answers)
    select_hash = {}
    answers.each do |answer|
      select_hash[answer] = answer
    end
    select_hash
  end
end

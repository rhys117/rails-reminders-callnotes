module RemindersHelper

  def sort_by_completed(reminders)
    complete_reminders, incomplete_reminders = reminders.partition { |r| r.complete }

    incomplete_reminders + complete_reminders
  end

  def inverse_complete_value(reminder)
    return 'incomplete' if reminder.complete
    return 'complete' if !reminder.complete
  end

  def combined_notes(reminder)
    combined = ""
    combined << "#{reminder.fault_type.upcase} | " unless reminder.fault_type.nil?
    combined << "#{reminder.notes} " unless reminder.notes.nil?
    combined << "#{reminder.check_for}?" unless reminder.check_for.nil?
    combined
  end

  def auto_manage_objects_to_array(hash_of_objects)
    hash_of_objects.each do |key, objects_array|
      hash_of_objects[key] = objects_array.map { |object| object.reference.to_i }
    end
    hash_of_objects
  end

  def reminder_priority(reminder)
    if reminder.complete
      'complete'
    else
      reminder.priority
    end
  end
end

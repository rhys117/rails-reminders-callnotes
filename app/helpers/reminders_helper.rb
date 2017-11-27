module RemindersHelper

  def sort_by_completed(reminders)
    complete_reminders, incomplete_reminders = reminders.partition { |r| r.complete }

    incomplete_reminders + complete_reminders
  end

  def inverse_complete_value(reminder)
    return 'Incomplete' if reminder.complete
    return 'Complete' if !reminder.complete
  end
end

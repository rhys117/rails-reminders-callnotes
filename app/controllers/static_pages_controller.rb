class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @reminders = current_user.reminders.ordered_priority.where('date <= ? AND complete= ?', Date.today, 'f')
      @reminder = Reminder.new
      @quick_notes = current_user.quick_notes.all
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end

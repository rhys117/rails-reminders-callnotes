class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @current_reminders = current_user.reminders.ordered_priority.where('date <= ? AND complete= ?', Date.current, 'f')
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

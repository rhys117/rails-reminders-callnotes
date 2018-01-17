namespace :delete do
  desc 'delete old completed reminders'
  task :old_complete_reminders => :environment do
    Reminder.where('complete = ? AND date < ?', true, Date.current).each do |reminder|
      reminder.destroy
    end
  end
end
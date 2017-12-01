class AddFaultTypeAndCheckForToReminders < ActiveRecord::Migration[5.0]
  def change
    add_column :reminders, :fault_type, :string
    add_column :reminders, :check_for, :string
  end
end

class ChangeCompleteTypeInReminders < ActiveRecord::Migration[5.0]
  def change
    change_table :reminders do |t|
      t.change :complete, :boolean, default: false
    end
  end

  def down
    change_table :reminders do |t|
      t.change :complete, :boolean
    end
  end
end

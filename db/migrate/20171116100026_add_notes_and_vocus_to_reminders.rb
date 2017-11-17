class AddNotesAndVocusToReminders < ActiveRecord::Migration[5.0]
  def change
    add_column :reminders, :notes, :string
    add_column :reminders, :vocus, :boolean
  end
end

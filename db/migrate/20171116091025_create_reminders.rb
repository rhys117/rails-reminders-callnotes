class CreateReminders < ActiveRecord::Migration[5.0]
  def change
    create_table :reminders do |t|
      t.date :date
      t.string :reference
      t.string :vocus_ticket
      t.string :nbn_search
      t.string :service_type
      t.integer :priority
      t.boolean :complete
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :reminders, [:user_id, :date]
  end
end

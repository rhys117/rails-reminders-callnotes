class CreateQuickNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :quick_notes do |t|
      t.string :category
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :quick_notes, [:user_id, :category]
  end
end

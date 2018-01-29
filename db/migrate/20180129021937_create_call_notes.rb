class CreateCallNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :call_notes do |t|
      t.datetime :time
      t.string :name
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

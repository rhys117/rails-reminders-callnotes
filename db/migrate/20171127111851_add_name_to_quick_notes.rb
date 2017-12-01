class AddNameToQuickNotes < ActiveRecord::Migration[5.0]
  def change
    add_column :quick_notes, :name, :string
  end
end

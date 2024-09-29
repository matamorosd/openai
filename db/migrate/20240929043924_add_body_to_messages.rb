class AddBodyToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :body, :text
    add_column :messages, :role, :integer
    remove_column :messages, :user_id
  end
end

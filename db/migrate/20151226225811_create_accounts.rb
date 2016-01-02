class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :username
      t.string :twitter_id
      t.string :display_name

      t.timestamps null: false
    end
  end
end

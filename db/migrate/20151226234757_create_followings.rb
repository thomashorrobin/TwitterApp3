class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.string :username
      t.string :twitter_id
      t.string :display_name

      t.timestamps null: false
    end
  end
end

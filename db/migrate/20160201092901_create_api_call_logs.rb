class CreateApiCallLogs < ActiveRecord::Migration
  def change
    create_table :api_call_logs do |t|
      t.string :calldescription
      t.datetime :calldatetime
      t.boolean :successful

      t.timestamps null: false
    end
  end
end

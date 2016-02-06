class AddRecordsInsertedToApiCallLog < ActiveRecord::Migration
  def change
    add_column :api_call_logs, :RecordsInserted, :integer
  end
end

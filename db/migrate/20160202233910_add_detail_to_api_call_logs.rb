class AddDetailToApiCallLogs < ActiveRecord::Migration
  def change
    add_column :api_call_logs, :EndPointPath, :string
    add_column :api_call_logs, :TwitterHandle, :string
  end
end

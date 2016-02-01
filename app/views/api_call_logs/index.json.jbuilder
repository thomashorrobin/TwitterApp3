json.array!(@api_call_logs) do |api_call_log|
  json.extract! api_call_log, :id, :calldescription, :calldatetime, :successful
  json.url api_call_log_url(api_call_log, format: :json)
end

every 1.day, at: '11:59 pm' do
  runner "DailyDigestJob.perform_now"
end

every 30.minutes do
  rake "ts:index"
end

namespace :todo do
  desc "Remove searches older than 2 days"
  task remove_old_searches: :environment do
    Search.delete_all ["created_at > ?", 2.days.ago]
  end
end

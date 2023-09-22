namespace :queries do
  desc "Reset queries_count"
  task reset: :environment do
    puts "Resetting all queries_count"
    User.update_all(queries_count: 0)
  end
end

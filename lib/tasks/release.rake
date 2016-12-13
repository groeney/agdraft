namespace :release do
  task :welcome_old_users => :environment do
    Worker.where(last_sign_in_at: nil).each do |w|
      w.welcome_to_new_site
    end
    Farmer.where(last_sign_in_at: nil).each do |f|
      f.welcome_to_new_site
    end
  end
end
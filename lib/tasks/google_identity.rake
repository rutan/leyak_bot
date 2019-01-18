namespace :google_identity do
  desc 'Googleアカウントを登録する'
  task :authorize => :environment do
    puts ::Models::GoogleIdentity.all

    ::Models::GoogleIdentity.authorize_or_register(ENV['OWNER_UID'])
  end
end

namespace :rails_admin do
  desc "Disable rails_admin initializer"
  task :disable_initializer do
    if ENV['SKIP_RAILS_ADMIN_INITIALIZER'].nil?
      ENV['SKIP_RAILS_ADMIN_INITIALIZER'] = 'true'
      puts "[RailsAdmin] RailsAdmin initialization disabled by default. Pass SKIP_RAILS_ADMIN_INITIALIZER=false if you need it."
    end
  end
  
  desc "Install rails_admin"
  task :install do
    system 'rails g rails_admin:install'
  end

  desc "Uninstall rails_admin"
  task :uninstall do
    system 'rails g rails_admin:uninstall'
  end
  
  desc "CI env for Travis"
  task :prepare_ci_env do
    ENV['SKIP_RAILS_ADMIN_INITIALIZER'] = 'true'
    adapter = ENV["CI_DB_ADAPTER"] || "sqlite3"
    database = ENV["CI_DB_DATABASE"] || ("sqlite3" == adapter ? "db/development.sqlite3" : "ci_rails_admin")

    configuration = {
      "test" => {
        "adapter" => adapter,
        "database" => database,
        "username" => ENV["CI_DB_USERNAME"],
        "password" => ENV["CI_DB_PASSWORD"],
        "host" => ENV["CI_DB_HOST"] || "localhost",
        "encoding" => ENV["CI_DB_ENCODING"] || "utf8",
        "pool" => (ENV["CI_DB_POOL"] || 5).to_int,
        "timeout" => (ENV["CI_DB_TIMEOUT"] || 5000).to_int
      }
    }

    filename = Rails.root.join("config/database.yml")

    File.open(filename, "w") do |f|
      f.write(configuration.to_yaml)
    end
  end
end

task :environment => 'rails_admin:disable_initializer'


# need to add this path for stand-alone migrations that use models

require 'rspec/core/rake_task'
require 'bundler/setup'
require 'travis'

include ActiveRecord::Tasks

db_dir = File.expand_path('../db', __FILE__)
config_dir = File.expand_path('../config', __FILE__)

DatabaseTasks.env = ENV['ENV'] || 'development'
DatabaseTasks.db_dir = db_dir
DatabaseTasks.database_configuration = YAML.load(ERB.new(File.read(File.join(config_dir, 'database.yml'))).result)
DatabaseTasks.migrations_paths = File.join(db_dir, 'migrate')

task :environment do
  require 'protected_attributes'
  ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
  ActiveRecord::Base.establish_connection Travis.env
end

load 'active_record/railties/databases.rake'

desc 'Run specs'
RSpec::Core::RakeTask.new do |t|
  t.pattern = './spec/**/*_spec.rb'
end

task :default => :spec

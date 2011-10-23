require 'active_record'
require 'yaml'

dbconfig = YAML::load(File.open("#{File.dirname(__FILE__)}/../../config/database.yml"))
ActiveRecord::Base.establish_connection(dbconfig['test'])

require 'rake'
require 'mongo'

require_relative 'populate_database'
require_relative '../../lib/gotasku'

namespace :db do
	desc "Create the database"
	task :create do
		client = Mongo::MongoClient.new
		db = client.db(Gotasku::DB_NAME) 
		collection = db.collection('owner')
		collection.insert({name: "John"})
	end

  desc "Drop the database"
	task :drop do
		Mongo::MongoClient.new.drop_database(Gotasku::DB_NAME)
	end
end

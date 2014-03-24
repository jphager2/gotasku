require 'rake'
require 'mongo'
require_relative '../../lib/gotasku'

namespace :problems do
  desc "Populate the problems collection"
	task :populate do
		client = Mongo::MongoClient.new
		db = client.db('sgf')
		collection = db.collection('problems')

		(0..Gotasku::Problem.last_problem_id).each do |id|
			if collection.find(id: id).first
				print '_'
				next
			end

			prob = Gotasku::Problem.new(id: id)

			begin 
				if prob.blank? == false 
					collection.insert(prob.data) 
					print '.'
				else
					print '*'
				end
			rescue
				print 'E'
			end
		end
	end

	desc "Structure the problems collection"
	task :structure do
		collection = Mongo::MongoClient.new.db('sgf').collection('problems')
	end
end

require_relative '../lib/gotasku'

require 'minitest/autorun'

require 'mongo'
require 'stringio'

# if Gotasku::Query is loaded, otherwise skip tests
if defined?(Gotasku::Query) 
	class GotaskuQueryTest < MiniTest::Unit::TestCase

		def test_makes_query
			query = Gotasku::Query.new({"id" => 1000})
			assert_kind_of Mongo::Cursor, query.found
		end

		def test_builds_query
			output = StringIO.new
			file = StringIO.new
			file << "y\n" << "1, 3\n" << "y\n" 
			file << "9, 15, 1\n" << "y\n" << "3\n"  
			file.rewind

			temp_in  = $stdin
			temp_out = $stdout
			$stdin   = file
			$stdout  = output

			query = Gotasku::Query.build

			$stdin  = temp_in
			$stdout = temp_out

			assert_kind_of Mongo::Cursor, query.found
		end

		def test_handles_big_query
			query = Gotasku::Query.new(
				{
					"id" => {"$lt" => 15000},
					"diff_num" => {"$gt" => 1, "$lt" => 9},
					"rating" => {"$in" => 
											["life and death",
											 "elementary"]}
				}
			)
			assert_kind_of Mongo::Cursor, query.found
		end

		def test_new_problem_from_database
			query = Gotasku::Query.new({"id" => 17642})
			prob = Gotasku::Problem.new("data" => query.to_a.first)
			assert prob.sgf 
			assert prob.id
		end
	end

else
  :skip_query_tests	
end

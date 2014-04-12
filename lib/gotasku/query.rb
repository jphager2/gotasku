# gotasku query object queries the mongo database
class Gotasku::Query 
	PROBLEMS = Mongo::MongoClient.new
		.db(Gotasku::DB_NAME).collection('problems')

	attr_reader :found

	# gets a Mongo::Cursor object from a query hash
	def initialize(query)
		@found = PROBLEMS.find(query) 
	end

	# builds a query and returns a Mongo::Cursor object
	def self.build
		self.new(self.build_query)
	end

	# returns an array of items in @found
	def to_a 
		@found.rewind!
		@found.to_a
	end

	private
	  # prompts user and returns true or false 
		def self.prompt_true_false(text, tru)
      print text

			response = gets.chomp.strip.downcase =~ /#{tru}/
		end

		# checks if response is valid
		def self.valid_response?(response)
      # throw an exception if the input is invalid
			letters = response.find {|item| item =~ /[a-z]/}
			response.class == Array and not(letters)
		end

	  # prompts user for input
		def self.prompt(text)
			print text

			response = gets.chomp.strip.downcase 
			
			# return an Array
			response = response.split(',')
					
			raise Gotasku::InvalidEntry unless self.valid_response?(response)

			response.collect {|item| item.to_i}
		end

	  # gets unique set of types from collection
		def self.get_types
			PROBLEMS.distinct(:type).sort
		end

		# gets unique set of difficulties from collection
		def self.get_difficulties
			PROBLEMS.distinct(:difficulty).sort do |one, two| 
				one = Gotasku::DifficultyString.new(one).to_i
				two = Gotasku::DifficultyString.new(two).to_i
				one <=> two 
			end
		end
		
	  # gets unique set of ratings from collection
		def self.get_ratings
			PROBLEMS.distinct(:rating).sort
		end

		# get query hash 
		def self.get_query
      query = {
				type:       -> {self.get_types},
				difficulty: -> {self.get_difficulties},
				rating:     -> {self.get_ratings}
			}
		end

		# prompts user for filtering by key 
		def self.prompt_for(key)
      if self.prompt_true_false(
					"Do you want to filter by #{key} (y/n)? ", 'y'
			  )
			  yield	
			end
		end

	  # runs a prompt to build a query for the database
		def self.build_query
			query = self.get_query	

			query.keys.each_with_object({}) do |key, query_build|
			  self.prompt_for(key) do 
					list = query[key].call
					Gotasku::Display.show(list)
					puts '=' * 40
					values = self.prompt(
						"Please type the index/number for the values " +
						"you would like to filter for (e.g. 0, 3, 4): ")

					values.collect! {|value| list[value]}
					query_build[key] = { "$in" => values }
				end
			end
		end
end

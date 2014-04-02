# gotasku query object queries the mongo database
class Gotasku::Query 
	@@problems = Mongo::MongoClient.new.db('sgf').collection('problems')

	attr_reader :found

	# gets a Mongo::Cursor object
	def initialize(query)
		@found = @@problems.find(query) 
	end

	# returns an array of items in @found
	def to_a 
		@found.rewind!
		@found.to_a
	end

	# returns a Mongo::Cursor object
	def self.create
		self.new(self.build_query)
	end

=begin
	# key is a string or symbol
	def self.sort_by(key)
	end

	# query is a hash 
	def self.query_by(query)
	end
=end

	private
	  # prompts user for input
		def self.prompt(text, tru = nil, fals = nil)
			print text

			response = gets.chomp.strip.downcase

      # if values are given to verrifying input as true/false
			if tru and fals 
				if response =~ /#{tru}/
					true
				elsif response =~ /#{fals}/
					false
				else
					nil
				end
			else # else return an Array
				response = response.split(',')

				# throw an exception if the input is invalid
				unless response.class == Array and 
					     not(response.find {|item| item =~ /[a-z]/})
					raise Gotasku::InvalidEntry
				end

				response.collect {|item| item.to_i}
			end
		end

	  # gets unique set of types from collection
		def self.get_types
			@@problems.distinct(:type).sort
		end

		# gets unique set of difficulties from collection
		def self.get_difficulties
			@@problems.distinct(:difficulty).sort do |one, two| 
				one = Gotasku::DifficultyString.new(one).convert
				two = Gotasku::DifficultyString.new(two).convert
				one <=> two 
			end
		end
		
	  # gets unique set of ratings from collection
		def self.get_ratings
			@@problems.distinct(:rating).sort
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
      if self.prompt("Do you want to filter by #{key} (y/n)? ", 
										 'y', 'n')
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

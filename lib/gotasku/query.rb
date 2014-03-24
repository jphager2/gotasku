class Gotasku::Query 
	@@problems = Mongo::MongoClient.new.db('sgf').collection('problems')

	def initialize
		query_run
	end

	# key is a string or symbol
	def self.sort_by(key)
	end

	# query is a hash 
	def self.query_by(query)
	end

	private
	  # prompts user for input
	  def prompt(text, tru = nil, fals = nil)
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
				response = response.gsub(/\s/, '').split(',')
				unless response.class == Array
					raise InvalidEntry
				end
			end
		end

	  #gets unique set of types from collection
	  def get_types
			@@problems.distinct(:type).sort
		end

		#gets unique set of difficulties from collection
		def get_difficulties
			@@problems.distinct(:difficulty).sort do |x, y| 
				x = Gotasku::DifficultyString.new(x).convert
				y = Gotasku::DifficultyString.new(y).convert
				x <=> y
			end
		end
		
	  #gets unique set of ratings from collection
	  def get_ratings
			@@problems.distinct(:rating).sort
		end

	  # runs a prompt to query the collection
	  def query_run
			q = {
						type: -> {get_types},
						difficulty: -> {get_difficulties},
						rating: -> {get_ratings}
			    }

			q.keys.each do |key|
				if prompt("Do you want to filter by #{key} (y/n)? ", 'y', 'n')
					Gotasku::Display.show(q[key].call)
					puts '=' * 40
					prompt("Please type the index/number for the values " +
								 "you would like to filter for (e.g. 0, 3, 4)")
				end
			end
		end

end

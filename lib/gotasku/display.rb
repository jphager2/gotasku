class Gotasku::Display 
	def self.show(problem)
    puts "=" * 40
	  puts "id: #{problem.id}"
	  puts "type: #{problem.type}"
		puts "rating: #{problem.rating}"
		puts "difficulty: #{problem.difficulty}"
		puts "=" * 40
	end
end


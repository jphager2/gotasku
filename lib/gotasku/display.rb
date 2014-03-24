class Gotasku::Display 
	def self.show_problem(problem)
    puts "=" * 40
	  puts "id: #{problem.id}"
	  puts "type: #{problem.type}"
		puts "rating: #{problem.rating}"
		puts "difficulty: #{problem.difficulty}"
		puts "=" * 40
	end

	def self.show_list(list)
		list.each_with_index {|item, i| puts "#{i}...#{item}"}
	end	

	def self.show(object)
		case object
		when ::Gotasku::Problem
			self.show_problem(object)
		when ::Array
			self.show_list(object)
		else
			puts "Sorry, I can't show that.."
		end
	end
end


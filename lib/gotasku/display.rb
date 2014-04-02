# Displays Gotasku and Ruby objects in human readable forms
class Gotasku::Display 

	

	# Displays the object correctly or says if it cannot display the object
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

	private
	  # Gives a line
	  def self.line
			"=" * 40
		end

		# Displays Gotasku::Problem
		def self.show_problem(problem)
			display =  [
									self.line,
									"id: #{problem.id}",
									"type: #{problem.type}",
									"rating: #{problem.rating}",
									"difficulty: #{problem.difficulty}",
								 ] 
			puts display, display.first
		end

		# Displays Array 
		def self.show_list(list)
			list.each_with_index {|item, index| puts "#{index}...#{item}"}
		end	
end


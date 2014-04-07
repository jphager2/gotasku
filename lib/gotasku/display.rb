# Displays Gotasku and Ruby objects in human readable forms
class Gotasku::Display 

	# convenience method 
	def self.show(object)
		new(object).show
	end

	# initialize with an object
	def initialize(object)
		@object = object
	end

	# Displays the object correctly or says it cannot display the object
	def show
		case @object
		when ::Gotasku::Problem
			show_problem(@object)
		when ::Array
			show_list(@object)
		else
			puts "Sorry, I can't show that.."
		end
	end

	private
	  # Gives a line
	  def line
			"=" * 40
		end

		# Displays Gotasku::Problem
		def show_problem(problem)
			display =  [
									line,
									"id: #{problem.id}",
									"type: #{problem.type}",
									"rating: #{problem.rating}",
									"difficulty: #{problem.difficulty}",
								 ] 
			puts display, display.first
		end

		# Displays Array 
		def show_list(list)
			list.each_with_index {|item, index| puts "#{index}...#{item}"}
		end	
end


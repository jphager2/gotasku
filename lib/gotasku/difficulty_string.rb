# Difficulty string is a string of the difficulty of a Gotasku::Problem 
class Gotasku::DifficultyString < String

	# convert difficulty string to number (e.g. "6 dan".convert => -6)
	def convert 
		int = self.slice(/\d+/).to_i

		if self =~ /p/ or self =~ /d/ #pro or dan
      # add ten if pro
		  int	+ 10 if self =~ /p/ 
      # mulitply by -1 
			(int * -1)
		elsif self =~ /k/ #kyu
		  # just number	
		  int	
		else
			nil
		end
	end
end

			


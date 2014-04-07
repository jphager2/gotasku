# difficulty string is a string of the difficulty of a gotasku problem 
class Gotasku::DifficultyString < String

	# convert difficulty string to number (e.g. "6 dan".convert => -6)
	# convert to integer implicit
	def to_int 
		int = Integer(self.slice(/\d+/))

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

	# convert to integer explicit
	def to_i 
		self.to_int 
	end
end

			


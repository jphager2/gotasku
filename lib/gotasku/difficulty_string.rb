class Gotasku::DifficultyString < String

	# convert difficulty string to number
	def convert 
	  case self
		when /p/ #pro
			# grab number, mulitply by -1 and subtract 10 
			(self.slice(/\d+/).to_i * -1) - 10
		when /d/ #dan
			# grab number, multiply by -1 
	  	(self.slice(/\d+/).to_i * -1)
		when /k/ #kyu
		  # grab number	
		  self.slice(/\d+/).to_i	
		else
			nil
		end
	end
end

			


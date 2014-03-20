class Gotasku::RatingString < String 

	# convert string to number
	def convert 
		sum = self.slice(/sitesum:\d+/).slice(/\d+/).to_i
		num = self.slice(/sitenum:\d+/).slice(/\d+/).to_i

		# find the average or return the sum (if num is 0)
		num == 0 ? 0 : sum / num 
	end
end

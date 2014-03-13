class Gotasku::Parser < SGF::Parser

	def parse(sgf)
    super(validate(sgf))	
	end

	# this is designed to only work for sgf text that has one set of
	# AB and one set of AW, won't work if there are any other AB or AW
	# in the middle of the tree
	def validate(sgf)
	  validate_for(validate_for(sgf, :AB), :AW)
	end

	# danger is if there is "AB" in a comment, e.g. "It's ABOUT time!"
	def validate_for(sgf, property)
		regs = {AB: /AB/, AW: /AW/}

		# find the first instance, all will be replaced and the first 
		# instance will be readded
		start = sgf =~ regs[property] 

		if start
			sgf.gsub!(regs[property], '')
			sgf = sgf[0...start] + property.to_s + sgf[start..-1]
		end

		sgf
	end

end

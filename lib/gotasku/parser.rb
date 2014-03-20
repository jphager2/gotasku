class Gotasku::Parser < SGF::Parser

	# validates and parses sgf string
	def parse(sgf)
    super(validate(sgf))	
	end

	# validates sgf string for common goproblems.com issues
	def validate(sgf)
	  validate_for(validate_for(sgf, :AB), :AW)
	end

	# validates for a property (AB or AW)
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

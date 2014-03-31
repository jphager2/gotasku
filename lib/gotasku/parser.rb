# Parses Gotask::Problem sgf
class Gotasku::Parser < SGF::Parser

  @@regs = {AB: /AB/, AW: /AW/}

	# validates and parses sgf string
	def parse(sgf)
		super(self.class.validate(sgf))	
	end

	# validates sgf string for common goproblems.com issues
	def self.validate(sgf)
		validate_for(validate_for(sgf, :AB), :AW)
	end

	# validates for a property (AB or AW)
	def self.validate_for(sgf, property)
		# find the first instance, all instances following 
		# will be replaced and the first instance will be readded
		property_regex = @@regs[property]
		start = sgf =~ property_regex	

		if start
			sgf.gsub!(property_regex, '')
			sgf[0...start] + property.to_s + sgf[start..-1]
		else
			sgf
		end
	end
end

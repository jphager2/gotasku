class Gotasku::Parser < SGF::Parser

	def parse(sgf)
    super(validate(sgf))	
	end

=begin
	def validate(sgf)

		temp = '<(" <) <( " )> (> ")>'

		index = 0

		# check next part of the string
		while sgf[index..-1] =~ /AB/
			puts 'got here 1'

			index = (sgf[index..-1] =~ /AB/)

			this_part = sgf[index..-1]

			ab_scan = this_part.scan(/\[[^W]+\]AB\[..\]/)
			this_part.gsub!(/\[[^W]+\]AB\[..\]/, temp)

			ab_scan.each do |slice| 
				slice.gsub!(/(\[..\])AB/) { "#{$1}" }
				this_part.sub!(temp, slice)
			end

			puts 'this_part is: ' + this_part
			sgf[index..-1] = this_part

		  index += 1
		end

		sgf
	end
=end

  def validate(sgf)
		regs = {black: /AB/, white: /AW/}
		[:black].each do |color|
			index = 0

			# check next part of the string
			while sgf[index..-1] =~ regs[color]

				# get the index of the next occurance
				index = (sgf[index..-1] =~ regs[color])

				# get substring from index to end
				this_part = sgf[index..-1]

				# validate the substring
				validate_part(this_part, color)

				# replace the validated substring
				sgf[index..-1] = this_part

				# move ahead, so this index won't match again
				index += 1
			end
		end

		sgf
	end


	# must return the sgf
	def validate_part(sgf, color)
		# changes bad sgf: AB[xx]AB[xx]AW[xx] => AB[xx][xx]AW[xx]
		temp = '<(" <) <( " )> (> ")>'

		ab_scan = sgf.scan(/\[[^W]+\]AB\[..\]/)
		sgf.gsub!(/\[[^W]+\]AB\[..\]/, temp)
	
    aw_scan = sgf.scan(/\[[^B]+\]AW/)
		sgf.gsub!(/\[[^B]+\]AW/, temp.reverse)
	
		ab_scan.each do |slice| 
			slice.gsub!(/(\[..\])AB/) { "#{$1}" }
			sgf.sub!(temp, slice)
		end

		aw_scan.each do |slice| 
			slice.gsub!(/(\[..\])AW/) { "#{$1}" }
			sgf.sub!(temp.reverse, slice)
		end	

		sgf
	end
end


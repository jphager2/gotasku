class Gotasku::Parser < SGF::Parser

	def parse(sgf)
    super(validate(sgf))	
	end

	# must return the sgf
	def validate(sgf)
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


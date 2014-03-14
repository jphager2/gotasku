class Gotasku::Problem

	@@uri = "http://www.goproblems.com/"

	attr_reader :id

	def initialize(options)
		@id  = options[:id]
		@sgf = options[:sgf]
	end

	def sgf 
		@sgf ||= begin
		  #get sgf from go problems  
							 doc = Nokogiri::HTML(open("#{@@uri}#{@id}").read) 
							 doc.css("div#player-container").text.gsub(/\r?\n/, '')
             end
	end

	def tree 
		@tree ||= ::Gotasku::Parser.new.parse(sgf)
	end

	def save
		tree.save("#{id}.sgf")
	end
end

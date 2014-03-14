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

	def upload
		# don't upload a problem that came from goproblems
		unless @id
			sess = Gotasku::Session.current

			add_info_page = sess.link_with(href: /add/).click
			add_page = add_info_page.link_with(text: /direct/).click

      add_page.form_with(
				action: 'addtest.php3') do |f|
				source_field = f.field_with(name: "source")
				source_field.value = ''
				
				name_field = f.field_with(name: "name")
				name_field.value = '' 

				sgf_field = f.field_with(name: "sgf")
				sgf_field.value = @sgf
				
				intro_field = f.field_with(name: "intro")
				intro_field.value = ''

        type_select = f.field_with(name: "genre")
				type_select.value = 'elementary' 
				
				group_select = f.field_with(name: "usergroup[]")
				group_select.value = ['none']

				@submit = f.submit
			end
		end
	end
end

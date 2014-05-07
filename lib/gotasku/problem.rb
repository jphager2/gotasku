# A gotasku go problem
class Gotasku::Problem

  BASE_URI = "http://www.goproblems.com/"

  attr_reader :id

  # initializes with a hash of options
  def initialize(options = {})
    @id   = options["id"]
    @sgf  = options["sgf"]
    @data = options["data"] 

    # overrides sgf and id if they are provided in the option data  
    if @data 
      @id   = @data["id"]  || @id
      @sgf  = @data["sgf"] || @sgf
    end

    # checks if sgf is a sgf file, and reads it if it is
    if @sgf =~ /\.sgf/ && File.exists?(@sgf)
      @sgf = File.open(@sgf, 'r').read
    end

    # if sgf is given, make sure @data is assigned (i.e. if @data works)
    if @sgf 
      @data ||= {}
    end
  end

  # get the id of the last problem on goproblems.com
  def self.last_problem_id
    @@LAST_PROBLEM_ID ||= begin
      doc = Nokogiri::HTML(open('http://www.goproblems.com/').read)
      links = doc.css('td a').select {|link| link[:href] =~ /^\/\d+\z/}
      links.first[:href].slice(/\d+/).to_i
    end
  end
  
  # print out information on problem on screen
  def display 
    Gotasku::Display.show(self)
  end

  # access sgf or strip problem sgf from goproblems.com 
  def sgf
    @sgf ||= data["sgf"]
  end

  # strip problem difficulty from goproblems.com
  def difficulty
    data["difficulty"]
  end

  # strip problem type from goproblems.com
  def type 
    data["type"]
  end

  # strip problem rating from goproblems.com 
  def rating 
    data["rating"]
  end

  # access or get the tree from the Parser
  def tree 
    @tree ||= Gotasku::Parser.new.parse(sgf)
  end

  # saves the sgf as a file 
  def save
    tree.save("#{id || Time.now.to_i}.sgf")
  end

  # this method is not finished
  # uploads sgf to goproblems.com 
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

      # after submit, goes to flash app to confirm and complete 
      # the problem
    end
  end

  # return true if problem has an empty sgf, else return false
  def blank?
    sgf == '(;)'
  end

  # get data for a problem
  def data 
    @data ||= Gotasku::Document.new("#{BASE_URI}#{@id}")
  end
end

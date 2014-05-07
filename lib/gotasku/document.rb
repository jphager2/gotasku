# gotasku nokogiri document
class Gotasku::Document < Hash

  def initialize(uri)
    @doc = Nokogiri::HTML(open(uri).read) 

    # get data from goproblems.com problems page
    begin
      self.merge!( 
        {
          "id"         => @id,
          "sgf"        => get_sgf, 
          "difficulty" => difficulty = get_difficulty, 
          "diff_num"   => difficulty.to_i,
          "type"       => get_type, 
          "rating"     => get_rating
        }
      )
    rescue Gotasku::NotFound, SocketError
      # at the moment, this seems the best solution, not ideal though
      # because it allows for problems to be saved even if they are not 
      # found
      self.merge!({sgf: '(;)'}) 
    end
  end

  private 
    # grabs sgf from document
    def get_sgf
      sgf = @doc.css("div#player-container").text.gsub(/\r?\n/, '')

      if sgf.empty?
        raise Gotasku::NotFound 
      else
        sgf 
      end
    end

    # grabs difficulty from document
    def get_difficulty
      Gotasku::DifficultyString.new(@doc.css("div.difficulty a").text)
    end

    # grabs type from document
    def get_type 
      @doc.css("div.prob_genre").text
    end

    # grabs rating from document
    def get_rating
      Gotasku::RatingString.new(
        @doc.css("div.probstars")[0][:class]).to_i
    end
end

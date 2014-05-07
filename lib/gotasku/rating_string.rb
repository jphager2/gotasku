# rating string is a string of the rating of a gotasku problem 
class Gotasku::RatingString < String 

  # convert string to number implicit
  def to_int 
    sum = Integer(self.slice(/sitesum:\d+/).slice(/\d+/))
    num = Integer(self.slice(/sitenum:\d+/).slice(/\d+/))

    # find the average or return the sum (if num is 0)
    num == 0 ? 0 : sum / num 
  end

  # convert string to number explicit
  def to_i 
    self.to_int 
  end
end

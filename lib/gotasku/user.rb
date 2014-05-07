# user for goproblems.com
class Gotasku::User 

  attr_reader :username, :password

  # initializes a new user with all the info needed to create a new
  # session
  def initialize(username, password)
    @username = username
    @password = password
  end
end

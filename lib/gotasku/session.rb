# login session for a user on goproblems.com
class Gotasku::Session

  @@current = nil

  attr_reader :account
  
  # uses mechanize to login to goproblems.com and makes makes this the
  # current session
  def initialize(user)
    mech = Mechanize.new
    mech.get('http://www.goproblems.com/') do |page|
      # Click the login link
      login_page = mech.click(page.link_with(href: /login/))

      # Submit the login form
      login_page.form_with(
                action: 'login.php') do |form|
        username_field       = form.field_with(name: "name")
        username_field.value = user.username
        
        password_field       = form.field_with(name: "password")
        password_field.value = user.password 

        @account = form.submit
      end
    end

    @@current = @account
  end

  # accesses current session
  def self.current 
    @@current
  end
end

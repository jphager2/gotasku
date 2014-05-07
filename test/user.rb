require 'minitest/autorun'
require_relative '../lib/gotasku'

require_relative '../variables'

class GotaskuUserTest < MiniTest::Unit::TestCase

  def setup
    @user = Gotasku::User.new(::USERNAME, ::PASSWORD)
  end

  def test_creates_user
    assert_kind_of Gotasku::User, @user
  end
end

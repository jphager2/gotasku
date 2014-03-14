require 'minitest/autorun'
require_relative '../lib/gotasku'

require_relative '../variables'

class GotaskuSessionTest < MiniTest::Unit::TestCase

	def setup
		@user = Gotasku::User.new(::USERNAME, ::PASSWORD)
		@session = Gotasku::Session.new(@user)
	end

	def test_creates_session
		assert_kind_of Gotasku::Session, @session
	end
end

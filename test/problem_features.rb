require 'minitest/autorun'
require_relative '../lib/gotasku'

class GotaskuFeatureTest < MiniTest::Unit::TestCase
	def setup
		@problem = Gotasku::Problem.new(id: 1000)
	end

	def test_gets_difficulty
		# 30k-1k, 1d-9d, 1p-9p => 30 - 1, -1 - -9, -11 - -19
		assert_equal '6 dan', @problem.difficulty 
	end

  def test_gets_difficulty_conversion_for_sorting
		# 30k-1k, 1d-9d, 1p-9p => 30 - 1, -1 - -9, -11 - -19
		assert_equal -6, @problem.difficulty.convert 
	end

	def test_gets_type
		assert_equal @problem.type, 'life and death'
	end

	def test_gets_rating 
		assert_equal @problem.rating, 3
	end
end


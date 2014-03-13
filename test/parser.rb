require 'minitest/autorun'
require_relative '../lib/gotasku'

class GotaskuTest < MiniTest::Unit::TestCase

	def test_initialize_parser
		assert_kind_of Gotasku::Parser, Gotasku::Parser.new
	end

  def test_inherits_for_sgf_parser
		assert_includes Gotasku::Parser.ancestors, SGF::Parser
	end

	def test_parses_correct_sgf
		sgf = '(;AB[lb][lc][ld][kc][jb][ka][ck][dg][ei])'
		parser = SGF::Parser.new
		gparser = Gotasku::Parser.new

		assert_equal parser.parse(sgf), gparser.parse(sgf)  
	end

	def test_validates_sgf
    correct_sgf = '(;AB[lb][lc][ld])'
		incorrect_sgf = '(;AB[lb]AB[lc]AB[ld])'

		gparser = Gotasku::Parser.new

		assert_equal correct_sgf, gparser.validate(incorrect_sgf)
	end

	def test_validates_sgf_with_AB_and_AW
 		correct_sgf = '(;AB[lb][lc][ld]AW[bb][cc])'
		incorrect_sgf = '(;AB[lb]AB[lc]AB[ld]AW[bb]AW[cc])'

		gparser = Gotasku::Parser.new

		assert_equal correct_sgf, gparser.validate(incorrect_sgf)
	end

	def test_parses_incorrect_sgf
		correct_sgf = '(;AB[lb][lc][ld])'
		incorrect_sgf = '(;AB[lb]AB[lc]AB[ld])'

    parser = SGF::Parser.new
		gparser = Gotasku::Parser.new

		assert_equal parser.parse(correct_sgf), gparser.parse(incorrect_sgf)
	end

	def test_parses_incorrect_sgf_with_AB_and_AW
		correct_sgf = '(;AB[lb][lc][ld]AW[bb][cc])'
		incorrect_sgf = '(;AB[lb]AB[lc]AB[ld]AW[bb]AW[cc])'
    
		parser = SGF::Parser.new
		gparser = Gotasku::Parser.new

		assert_equal parser.parse(correct_sgf), gparser.parse(incorrect_sgf)
	end
end

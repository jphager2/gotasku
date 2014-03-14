require 'minitest/autorun'
require_relative '../lib/gotasku'

class GotaskuParserTest < MiniTest::Unit::TestCase
	def setup
		@parser = SGF::Parser.new
		@gparser = Gotasku::Parser.new
	end

	def test_initialize_parser
		assert_kind_of Gotasku::Parser, Gotasku::Parser.new
	end

  def test_inherits_for_sgf_parser
		assert_includes Gotasku::Parser.ancestors, SGF::Parser
	end

	def test_parses_correct_sgf
		sgf = '(;AB[lb][lc][ld][kc][jb][ka][ck][dg][ei])'

		assert_equal @parser.parse(sgf), @gparser.parse(sgf)  
	end

	def test_validates_sgf
    correct_sgf = '(;AB[lb][lc][ld])'
		incorrect_sgf = '(;AB[lb]AB[lc]AB[ld])'

		assert_equal correct_sgf, @gparser.validate(incorrect_sgf)
	end

	def test_validates_sgf_with_AB_and_AW
 		correct_sgf = '(;AB[lb][lc][ld]AW[bb][cc])'
		incorrect_sgf = '(;AB[lb]AB[lc]AB[ld]AW[bb]AW[cc])'

		assert_equal correct_sgf, @gparser.validate(incorrect_sgf)
	end

	def test_parses_incorrect_sgf
		correct_sgf = '(;AB[bb][bb][bb])'
		incorrect_sgf = '(;AB[bb]AB[bb]AB[bb])'

		assert_equal @parser.parse(correct_sgf), 
			           @gparser.parse(incorrect_sgf)
	end

	def test_parses_incorrect_sgf_with_AB_and_AW
		correct_sgf = '(;AB[lb][lc][ld]AW[bb][cc])'
		incorrect_sgf = '(;AB[lb]AB[lc]AB[ld]AW[bb]AW[cc])'
    
		assert_equal @parser.parse(correct_sgf), 
			           @gparser.parse(incorrect_sgf)
	end

	def test_full_incorrect_sgf_AB
		incorrect_sgf = '(;AW[pe]AW[pf]AW[qg]AW[qh]AW[oi]AW[ri]AW[oj]AW[pj]AW[rj]AW[sk]AW[rl]AW[sl]AW[rm]AB[pg]AB[ph]AB[rh]AB[pi]AB[qi]AB[qj]AB[pk]AB[qk]AB[rk]AB[pl]C[black to do something effective on the side]SZ[19]GM[1]FF[3]RU[Japanese]HA[0]KM[5.5]PW[White]PB[Black]GN[White (W) vs. Black (B)]DT[1999-07-27]SY[Cgoban 1.9.2]TM[30:00(5x1:00)](;B[sh](;W[sj](;B[qf];W[rg];B[rf]C[RIGHT])(;B[rg];W[qf]))(;W[rg];B[sj];W[si];B[sj]C[snapbackRIGHT]))(;B[sj];W[si](;B[sh];W[sj](;B[qf];W[rg])(;B[rg];W[qf]))(;B[qf];W[rg])(;B[rg];W[qf]))(;B[rg];W[qf]C[black has nothing now])(;B[qf];W[rg](;B[sh];W[sg])(;B[rf];W[sh]))(;B[sj];W[si](;B[sh];W[sj](;B[qf];W[rg])(;B[rg];W[qf]))(;B[qf];W[rg])(;B[rg];W[qf]))(;B[qn];W[rg])(;B[qm];W[rg])(;B[rn];W[rg])(;B[rf];W[rg])(;B[sg];W[rg]))'
		
		validated_sgf = @gparser.validate(incorrect_sgf)

		refute_match /AB\[..\]AB/, validated_sgf 
		assert_match /AB/, validated_sgf
	end

	def test_full_incorrect_sgf_AW
    incorrect_sgf = '(;AW[pe]AW[pf]AW[qg]AW[qh]AW[oi]AW[ri]AW[oj]AW[pj]AW[rj]AW[sk]AW[rl]AW[sl]AW[rm]AB[pg]AB[ph]AB[rh]AB[pi]AB[qi]AB[qj]AB[pk]AB[qk]AB[rk]AB[pl]C[black to do something effective on the side]SZ[19]GM[1]FF[3]RU[Japanese]HA[0]KM[5.5]PW[White]PB[Black]GN[White (W) vs. Black (B)]DT[1999-07-27]SY[Cgoban 1.9.2]TM[30:00(5x1:00)](;B[sh](;W[sj](;B[qf];W[rg];B[rf]C[RIGHT])(;B[rg];W[qf]))(;W[rg];B[sj];W[si];B[sj]C[snapbackRIGHT]))(;B[sj];W[si](;B[sh];W[sj](;B[qf];W[rg])(;B[rg];W[qf]))(;B[qf];W[rg])(;B[rg];W[qf]))(;B[rg];W[qf]C[black has nothing now])(;B[qf];W[rg](;B[sh];W[sg])(;B[rf];W[sh]))(;B[sj];W[si](;B[sh];W[sj](;B[qf];W[rg])(;B[rg];W[qf]))(;B[qf];W[rg])(;B[rg];W[qf]))(;B[qn];W[rg])(;B[qm];W[rg])(;B[rn];W[rg])(;B[rf];W[rg])(;B[sg];W[rg]))'
		
		validated_sgf = @gparser.validate(incorrect_sgf)
		
		refute_match /AW\[..\]AW/, validated_sgf 
		assert_match /AW/, validated_sgf
	end

	def test_does_not_start_with_stone_positions
		incorrect_sgf = '(;GM[1]FF[3]RU[Japanese]SZ[19]HA[0]KM[5.5]PW[White]PB[Black]GN[White (W) vs. Black (B)]DT[1999-07-28]SY[Cgoban 1.9.2]TM[30:00(5x1:00)];AW[ba]AW[ca]AW[ea]AW[bb]AW[eb]AW[cc]AW[ec]AW[ed]AW[ce]AW[de]AW[ee]AB[fa][fb][fc][bd][cd][dd][fd][be][fe][bf][cf][df][ef][ff](;B[dc];W[db];B[bc];W[ab]C[only ko])(;B[db];W[dc];B[ab];W[ac];B[bc]C[RIGHT])(;B[bc];W[db];B[dc];W[ab]C[only ko])(;B[ab];W[db](;B[dc];W[bc])(;B[bc];W[dc]))(;B[ac];W[ab]))'

		validated_sgf = @gparser.validate(incorrect_sgf)
	
		assert_match /AW/, validated_sgf
		refute_match /AW\[..\]AW/, validated_sgf
	end

end

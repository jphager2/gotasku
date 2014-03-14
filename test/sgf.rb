require 'minitest/autorun'
require_relative '../lib/gotasku'

class GotaskuProblemTest < MiniTest::Unit::TestCase
	def setup
		@problem = Gotasku::Problem.new(17625)
	end

	def test_gets_id
		assert_equal 17625, @problem.id
	end

	def test_gets_sgf
		sgf = '(;AB[se]AB[rd]AB[qd]AB[qe]AB[qf]AB[qg]AB[oe]AB[oc]AB[pc]AB[ob]AW[mb]AW[mc]AW[me]AW[mg]AW[og]AW[ph]AW[qh]AW[rg]AW[re]AW[rf]AW[sc]AW[qc]AW[qb]AW[pb]AW[rb]AP[goproblems]
(;B[ra]
(;W[rc]
(;B[sd];W[sa];B[sb]C[CHOICERIGHT])
(;B[pa];W[qa])
(;B[qa];W[pa])
(;B[sa];W[sd])
(;B[sb];W[qa]))
(;W[sd];B[sb]C[RIGHT]))
(;B[oa];W[sd])
(;B[pa];W[sd])
(;B[qa];W[pa])
(;B[sa];W[sd])
(;B[sb];W[rc]TR[sd]TR[sa])
(;B[rc];W[sb]TR[sd]TR[pa]))'.gsub(/\r?\n/, '')

		assert_equal sgf, @problem.sgf
	end

	def test_gets_another_sgf
		sgf = '(;GM[1]FF[4]VW[]AP[Many Faces of Go:10.0]
SZ[13]
HA[0]
ST[1]
DT[2001-08-13]
KM[0.0]
RU[GOE]
AB[lb][lc][ld][kc][jb][ka][ck][dg][ei][fb][fc][fd][ee][db][cd][ej][fk][fl][fh][eg][fg][lj][kk][jj][ij][md][lf][gm][fm][gc]
AW[ib][jc][kd][jd][le][jf][hc][fi][gb][gd][fe][ff][ia][fj][gl][gk][gh][gg][jk][kg][lh][kl][ll][ik][me][ke][hm][hl]
C[After the previous problem, Black has played at 1 rather than
protecting his corner.  How can white punish him?
]
PL[W]LB[gc:A]
(;W[mb]
(;B[ma]
(;W[la];B[ge];W[ma];B[mc];W[ja];B[ma];W[kb]
C[White has given up too much when black plays A
]LB[ge:A]
)
(;W[ja];B[kb];W[la]
C[RIGHT
]))
(;B[ja];W[la]))
(;W[ja];B[mb]
C[Black is unconditionally alive.
])
(;W[ge];B[ja]
C[Black has had another chance to repair his defect.
]))'.gsub(/\r?\n/, '')

		assert_equal sgf, Gotasku::Problem.new(1000).sgf
	end

	def test_gets_tree_for_sgf
		assert_kind_of ::SGF::Tree, @problem.tree 
	end

	def test_saves_problem
		file = Dir.pwd + '/17625.sgf'

		File.delete(file) if File.exist?(file)
		@problem.save

		assert_includes Dir.glob(Dir.pwd + '/*.sgf'), file
	end
end

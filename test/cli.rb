require_relative '../lib/gotasku'

require 'minitest/autorun'
require 'stringio'


load 'variables.rb' # username and password for testing

class GotaskuCLITest < MiniTest::Unit::TestCase

	def test_get_problem
	  io = StringIO.new
		io.puts(`./bin/gotasku`)
		io.rewind
		assert_match /Gotasku::Problem/, io.read
	end

	def test_get_problem_with_id
		io = StringIO.new
		io.puts(`./bin/gotasku --id 1000`)
		io.rewind
		assert_match /@id=1000/, io.read
	end

	def test_get_problem_with_sgf
		io = StringIO.new
		io.puts(`./bin/gotasku --sgf '(;AB[aa][bb][cc]AW[dd][ee])'`)
		io.rewind 
		assert_includes io.read, "AB[aa][bb][cc]AW[dd][ee]" 
	end

	def test_get_problem_with_sgf_from_file
		File.open('./test/john.sgf', 'w') {|f| f.write('(;AW[cc][cd][ad]AB[aa])')}
    io = StringIO.new
		io.puts(`./bin/gotasku --sgf ./test/john.sgf`)
		io.rewind 
		assert_includes io.read, "AW[cc]" 
	end

  def test_save_problem
    name = '1000.sgf'

		File.delete(name) if File.exists?(name) 
		`./bin/gotasku save --id 1000 --sgf '(;AB[aa][bb][cc]AW[ab][bc][cd])'`
		assert_includes Dir.glob('*.sgf'), name 
	end

  def test_display_problem_data
		io = StringIO.new
		io.puts(`./bin/gotasku display --id 1000`)
		io.rewind
		output = io.read
		assert_match /id: 1000/, output
		assert_match /type: life and death/, output
		assert_match /rating: 3/, output
		assert_match /difficulty: 6 dan/, output
	end

	def test_login
		io = StringIO.new
		io.puts(`./bin/gotasku login --username #{::USERNAME} --password #{::PASSWORD}`)
    io.rewind
		assert_match /Gotasku::Session/, io.read
	end

=begin
  def test_get_problems_list_by_difficulty
	end

  def test_get_problems_list_by_rating
	end

  def test_get_problems_list_by_type
	end
=end
end


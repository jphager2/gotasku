gotasku
=======

Saving and opening tsumego

	_Use_

  *Problem*

	New problem. You can provide "id", "sgf", or "data" options.
		"id" => Integer (id of goproblem.com problem)
		"sgf" => String or File of SGF
		"data" => Hash with any of the following keys 
							("id", "sgf", "difficulty", 
							 "diff_num", "type", "rating") 

	Gotasku::Problem.new(options)

	Gotasku::Problem.new("id" => 1000)

	Gotasku::Problem.new("sgf" => "problem.sgf")
	Gotasku::Problem.new("sgf" => "(;AB[aa]AW[ab]")

	Gotasku::Problem.new("data" => {"id" => 1000,
																	"sgf" => "(;AB[aa]AW[ab])",
																	"difficulty" => "6 dan",
																	"diff_num" => -6,
																	"type" => "life and death",
																	"rating" => 3})

	You can access Problem data with #sgf, #id, #difficulty, #type, 
	 #rating, and #data instance methods

	prob = Gotasku::Problem.new("id" => 10000)
	prob.data
	prob.difficulty

	Gotasku use SgfParser to parse the SGF and save it.

	You can get the tree from SGF with the #tree instance method

	prob.tree

	And you can save the file with the #save instance method 

	prob.save

	The file will be saved as "#{id}.sgf" or using a time stamp if no id.

	\*see MongoDB for more


	*User*

	You can create a user object.

	user = Gotasku::User.new('username', 'password')

	*Session*

	You can login to goproblems.com by creating a new session object.
	The current session is saved in the @@current\_session class variable 

	Gotasku::Session.new(user)


	_*For MongoDB*_

	If you have MongoDB installed, you can run the rake tasks from the 
	root directory of the gem:

	rake db:create
	rake problems

	The first will create the database, the second will populate a 
	collection with all the go problems from goproblems.com.

	_Querying_

	You can build a query with Gotasku::Query.create (you will be prompted
	on how you want to filter the problems collection.

	Gotasku::Query.create

	Or you can query the collection directly Gotasku::Query.new(query\_hash)

	Gotasku::Query.new({"id" => 1000})

	This returns a Gotasku::Query object, with an instance variable (@found)
	that holds the Mongo::Cursor object from the query.

	query = Gotasku::Query.new({"type" => "life and death"})
	query.found 

	Gotasku::Query has a #to\_a instance method to get an array from the
	Mongo::Cursor object.

	query.to\_a

	*Problem* 

	index = 0
	Gotasku::Problem.new("data", query.to\_a[index])

  _Executable_

  There is an executable in the bin folder, which you can add to your 
  PATH. It provides commands for getting data from or saving single 
  problems.

  gotasku --id 1000

  gotasku --sgf "(;AW\[aa\]\[ab\]\[ac\]AB\[bb\]\[cc\])"



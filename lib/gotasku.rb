require 'open-uri'
require 'nokogiri'
require 'sgf'
require 'mechanize'
require 'mongo'

require_relative 'gotasku/gotasku'

require_relative 'gotasku/exceptions'
require_relative 'gotasku/problem'
require_relative 'gotasku/document'
require_relative 'gotasku/difficulty_string'
require_relative 'gotasku/rating_string'
require_relative 'gotasku/display'
require_relative 'gotasku/parser'
require_relative 'gotasku/user'
require_relative 'gotasku/session'

# only require Gotasku::Query if mongo db 'sgf' is found
is_db = Mongo::MongoClient.new.database_names.include?(Gotasku::DB_NAME)
require_relative 'gotasku/query' if is_db 

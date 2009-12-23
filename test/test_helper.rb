require "test/unit"
require "action_controller"
require "action_view"
require "action_view/test_case"
require "active_record"

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
  :database => ":memory:"

ActiveRecord::Base.connection.class.class_eval do
  IGNORED_SQL = [/^PRAGMA/, /^SELECT currval/, /^SELECT CAST/, /^SELECT @@IDENTITY/, /^SELECT @@ROWCOUNT/, /^SAVEPOINT/, /^ROLLBACK TO SAVEPOINT/, /^RELEASE SAVEPOINT/, /SHOW FIELDS/]

  def execute_with_query_record(sql, name = nil, &block)
    $queries_executed ||= []
    $queries_executed << sql unless IGNORED_SQL.any? { |r| sql =~ r }
    execute_without_query_record(sql, name, &block)
  end

  alias_method_chain :execute, :query_record
end

ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define(:version => 1) do
  create_table :blogs do |t|
  end

  create_table :topics do |t|
    t.belongs_to :blog
  end
end

class Blog < ActiveRecord::Base
  has_many :topics
end

class Topic < ActiveRecord::Base
  belongs_to :blog
end

blog = Blog.create
5.times { blog.topics.create }

module ApplicationHelper
end

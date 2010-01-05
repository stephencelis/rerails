require "test_helper"
require "reactive_record/first_last_limits"

class FirstLastLimits < ActiveRecord::TestCase
  test "first with limit" do
    first_two = assert_sql /LIMIT\s+2/ do
      Topic.first(2)
    end
    assert_equal Topic.all(:limit => 2), first_two
    assert_kind_of Array, Topic.first(1)
    assert_kind_of Topic, Topic.first
  end

  test "last with limit" do
    last_two = Topic.last(2)
    assert_equal Topic.all(:limit => 2, :order => "id DESC").reverse, last_two
  end

  test "association first with limit" do
    blog = Blog.first
    assert_sql /LIMIT\s+2/ do
      assert_kind_of Array, blog.topics.first(2)
    end
  end

  test "association last with limit" do
    blog = Blog.last
    assert_sql /LIMIT\s+2/ do
      assert_kind_of Array, blog.topics.last(2)
    end
  end

  test "scoped first with limit" do
    assert_kind_of Topic, Topic.scoped({}).first
    assert_sql /LIMIT\s+2/ do
      Topic.scoped({}).first(2)
    end
  end

  test "scoped last with limit" do
    assert_kind_of Topic, Topic.scoped({}).last
    assert_sql /LIMIT\s+2/ do
      Topic.scoped({}).last(2)
    end
  end
end

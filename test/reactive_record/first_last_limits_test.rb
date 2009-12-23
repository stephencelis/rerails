require "test_helper"
require "reactive_record/first_last_limits"

class FirstLastLimits < ActiveRecord::TestCase
  test "find first with limit" do
    first_two = assert_sql /LIMIT 2/ do
      Topic.find(:first, :limit => 2)
    end
    assert_equal Topic.find(:all, :limit => 2), first_two
    assert_kind_of Array, Topic.find(:first, :limit => 1)
    assert_kind_of Topic, Topic.find(:first)
  end

  test "first with limit" do
    assert_equal Topic.find(:first, :limit => 2), Topic.first(2)
  end

  test "find last with limit" do
    last_two = Topic.find(:last, :limit => 2)
    assert_equal Topic.find(:all, :limit => 2, :order => "id DESC").reverse, last_two
  end

  test "last with limit" do
    assert_equal Topic.find(:last, :limit => 2), Topic.last(2)
  end

  test "association first with limit" do
    blog = Blog.first
    assert_sql /LIMIT 2/ do
      assert_kind_of Array, blog.topics.first(2)
    end
  end

  test "association last with limit" do
    blog = Blog.last
    assert_sql /LIMIT 2/ do
      assert_kind_of Array, blog.topics.last(2)
    end
  end

  test "scoped first with limit" do
    assert_kind_of Topic, Topic.scoped({}).first
    assert_sql /LIMIT 2/ do
      Topic.scoped({}).first(2)
    end
  end

  test "scoped last with limit" do
    assert_kind_of Topic, Topic.scoped({}).last
    assert_sql /LIMIT 2/ do
      Topic.scoped({}).last(2)
    end
  end
end

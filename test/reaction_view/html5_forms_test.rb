require "test_helper"
require "reaction_view/html5_forms"
require "ostruct"

class HTML5Forms < ActionView::TestCase
  tests ApplicationHelper

  test "search field tag" do
    expected = %{<input id="query" name="query" type="search" />}
    assert_dom_equal(expected, search_field_tag("query"))
  end

  test "search field tag with autosave" do
    @host = "example.com"
    expected = %{<input results="10" name="query" autosave="com.example" id="query" type="search" />}
    assert_dom_equal(expected, search_field_tag("query", nil, :autosave => true))
  end

  test "search field tag with specified autosave and results" do
    expected = %{<input results="5" name="query" autosave="org.example" id="query" type="search" />}
    assert_dom_equal(expected, search_field_tag("query", nil, :autosave => "org.example", :results => 5))
  end

  test "search field tag sets incremental with onsearch" do
    expected = %{<input name="query" incremental="true" id="query" type="search" onsearch="console.log('Searching...');" />}
    assert_dom_equal(expected, search_field_tag("query", nil, :onsearch => "console.log('Searching...');"))
  end

  test "telephone field tag" do
    expected = %{<input id="cell" name="cell" type="tel" />}
    assert_dom_equal(expected, telephone_field_tag("cell"))
  end

  test "url field tag" do
    expected = %{<input id="homepage" name="homepage" type="url" />}
    assert_dom_equal(expected, url_field_tag("homepage"))
  end

  test "email field tag" do
    expected = %{<input id="address" name="address" type="email" />}
    assert_dom_equal(expected, email_field_tag("address"))
  end

  test "number field tag" do
    expected = %{<input name="quantity" max="9" id="quantity" type="number" min="1" />}
    assert_dom_equal(expected, number_field_tag("quantity", nil, :in => 1...10))
  end

  test "range input tag" do
    expected = %{<input name="volume" step="0.1" max="11" id="volume" type="range" min="0" />}
    assert_dom_equal(expected, range_field_tag("volume", nil, :in => 0..11, :step => 0.1))
  end

  test "search field" do
    expected = %{<input id="contact_notes_query" size="30" name="contact[notes_query]" type="search" />}
    assert_dom_equal(expected, search_field("contact", "notes_query"))
  end

  test "telephone field" do
    expected = %{<input id="user_cell" size="30" name="user[cell]" type="tel" />}
    assert_dom_equal(expected, telephone_field("user", "cell"))
  end

  test "url field" do
    expected = %{<input id="user_homepage" size="30" name="user[homepage]" type="url" />}
    assert_dom_equal(expected, url_field("user", "homepage"))
  end

  test "email field" do
    expected = %{<input id="user_address" size="30" name="user[address]" type="email" />}
    assert_dom_equal(expected, email_field("user", "address"))
  end

  test "number field" do
    expected = %{<input name="order[quantity]" size="30" max="9" id="order_quantity" type="number" min="1" />}
    assert_dom_equal(expected, number_field("order", "quantity", :in => 1...10))
  end

  test "range input" do
    expected = %{<input name="hifi[volume]" step="0.1" size="30" max="11" id="hifi_volume" type="range" min="0" />}
    assert_dom_equal(expected, range_field("hifi", "volume", :in => 0..11, :step => 0.1))
  end

  test "html5 form fields in form_for block" do
    form_for :phone, :url => "http://example.com" do |f|
      concat f.search_field(:model)
      concat f.url_field(:more_info)
      concat f.telephone_field(:number)
      concat f.email_field(:email)
      concat f.number_field(:minutes_free)
      concat f.range_field(:plan_number, :in => 1..5)
    end

    expected = %{<form action="http://example.com" method="post">} +
      %{<input id="phone_model" name="phone[model]" size="30" type="search" />} +
      %{<input id="phone_more_info" name="phone[more_info]" size="30" type="url" />} +
      %{<input id="phone_number" name="phone[number]" size="30" type="tel" />} +
      %{<input id="phone_email" name="phone[email]" size="30" type="email" />} +
      %{<input id="phone_minutes_free" name="phone[minutes_free]" size="30" type="number" />} +
      %{<input id="phone_plan_number" max="5" min="1" name="phone[plan_number]" size="30" type="range" />} +
      %{</form>}

    assert_equal expected, output_buffer
  end

  private

  def request
    OpenStruct.new(:host => @host)
  end
end

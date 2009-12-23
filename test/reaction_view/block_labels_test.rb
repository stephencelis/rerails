require "test_helper"
require "reaction_view/block_labels"

class BlockLabels < ActionView::TestCase
  tests ApplicationHelper

  test "label tag with block" do
    assert_dom_equal('<label>Blocked</label>', label_tag { "Blocked" })
  end

  test "label tag with block and argument" do
    output = label_tag("clock") { "Grandfather" }
    assert_dom_equal('<label for="clock">Grandfather</label>', output)
  end

  test "label with block" do
    output = label(:post, :title) { "Redacted" }
    assert_dom_equal('<label for="post_title">Redacted</label>', output)
  end

  test "form helper label with block" do
    form_for :post, :url => "http://example.com" do |f|
      concat f.check_box :tos
      f.label(:tos) { "Accept the <a>Terms of Service</a>." }
    end

    expected = %{<form action="http://example.com" method="post">} +
      %{<input name="post[tos]" type="hidden" value="0" />} +
      %{<input id="post_tos" name="post[tos]" type="checkbox" value="1" />} +
      %{<label for="post_tos">Accept the <a>Terms of Service</a>.</label>} +
      %{</form>}

    assert_equal expected, output_buffer
  end
end

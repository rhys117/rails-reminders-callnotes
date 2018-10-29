require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:rhys)
    log_in_as(@admin)
  end

  test "layout links" do
    get root_path
    assert_template 'shared/_logged_in'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", new_reminder_path
    assert_select "a[href=?]", new_quick_note_path
    assert_select "a[href=?]", new_call_note_path
    assert_select "a[href=?]", about_path
  end
end

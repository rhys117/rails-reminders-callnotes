require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h2', text: @user.name
    @user.reminders.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end

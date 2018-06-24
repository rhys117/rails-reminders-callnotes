require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:rhys)
    @non_admin = users(:archer)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@admin)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@admin), params: { user: {name: @admin.name,
                                              correspondence: @admin.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

    test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@non_admin)
    assert_not @non_admin.admin?
    patch user_path(@non_admin), params: {
                                    user: { password:              'foobar',
                                            password_confirmation: 'foobar',
                                            admin: true } }
    assert_not @non_admin.admin?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@admin)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as @non_admin
    assert_no_difference 'User.count' do
      delete user_path(@admin)
    end
    assert_redirected_to root_url
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end

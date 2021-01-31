require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @non_activated_user = users(:non_activated)
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password: @other_user.password,
                                            password_confirmation:  @other_user.password,
                                            admin: true} }
    assert_not @other_user.reload.admin?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  # test "should not allow the not activated attribute" do
  #   https://qiita.com/yokoyan/items/5ff9b93f67aabe8e0af4
  #   log_in_as(@non_activated_user)
  #   assert_not @non_activated_user.activated?
  #   get users_path
  #   assert_select "a[href=?]", user_path(@non_activated_user), count: 0
  #   get user_path(@non_activated_user)
  #   assert_redirected_to root_url
  # end

  test "index only activated user" do
    # https://yukitoku-sw.hatenablog.com/entry/2019/10/29/195657#%E5%95%8F%E9%A1%8C%EF%BC%92
    log_in_as(@user)
    get users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", user_path(@non_activated_user), count: 0
  end

  test "show only activated user" do
    # https://yukitoku-sw.hatenablog.com/entry/2019/10/29/195657#%E5%95%8F%E9%A1%8C%EF%BC%92
    log_in_as(@user)
    get user_path(@user)
    get user_path(@non_activated_user)
    assert_redirected_to root_url
  end

  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end

end

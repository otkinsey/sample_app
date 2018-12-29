require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users('okoa')
  end
  test "login with invalid information" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: " ", password: " " } }
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", login_path,   count: 0
    assert_select "a[href=?]", logout_path
    # puts "[user_login_test.rb: login with valid information followed by logout] - logout_path: #{users_path} \n\n"
    assert_select "a[href=?]", users_path
    delete logout_path
    assert_not logged_in?
    assert_redirected_to root_url

    # simulate a user clicking logout in a second window
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    puts "[user_login_test.rb: login with remembering] - remember_token: #{assigns(:user).remember_token} \n\n"
    # assert_not_empty cookies['remember_token']
    assert_not_empty assigns(:user).remember_token
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '1')
    log_in_as(@user, remember_me: '0')
    # puts "[user_login_test.rb: login without remembering] - remember_token: #{cookies['remember_token']} \n\n"
    assert_empty cookies['remember_token']
  end
end

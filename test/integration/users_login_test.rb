require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

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
    post login_path, params: { session: { email: @test_user.email,
                                          password: 'komet1' } }
    puts "[user_login_test] - #{@test_user.email} \n\n"
    assert logged_in?
    assert_redirected_to @test_user
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", login_path,   count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@test_user)
    delete logout_path
    assert_not logged_in?
    assert_redirected_to root_url

    # simulate a user clicking logout in a second window
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@test_user), count: 0
  end

end

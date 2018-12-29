require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:okoa)
    @user2 = users(:michael)
  end
  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user:
                                      { name: @user.name,
                                        email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  test "should redirect edit when not logged in as wrong user" do
    log_in_as(@user)
    get edit_user_path(@user2)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when not logged in as wrong user" do
    log_in_as(@user)
    patch user_path(@user2), params: { user:
                                      { name: @user2.name,
                                        email: @user2.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in " do
    get users_path
    assert_redirected_to login_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(users(:archer))
    # assert_equal @user2.email, 'mhartl@test.com'
    # assert_equal @user2.password_digest, User.digest('mhartl')
    assert_redirected_to user_path(users(:archer))
    assert_not users(:archer).admin?
    patch user_path(users(:archer)), params: { user: {
                                        password: "password",
                                        password_confirmation: "pasword",
                                        admin: true
      }}
    assert_not users(:archer).reload.admin?
  end

  test "should redirect destroy to login page if user not logged in" do
    assert_no_difference 'User.all.count' do
      delete user_path(@user)
    end

    assert_redirected_to login_url
  end

  test "should redirect destroy to home page if user not admin" do
    log_in_as(@user)
    assert_no_difference 'User.all.count' do
      delete user_path(users(:archer))
    end
    assert_redirected_to root_url
  end
end

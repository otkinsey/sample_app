require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '',
                                         email: 'user@invalid',
                                         password: 'foo',
                                         password_confirmation: 'bar' } }
    end
    assert_template 'users/new'
    assert_select 'div.error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                                         email: "example@example.com",
                                         password: "password",
                                         password_confirmation: "password"} }
      end
      assert_equal 1, ActionMailer::Base.deliveries.size
      user = assigns(:user)
      assert_not user.activated?
      # try to login before activation
      log_in_as(user)
      assert_not user.activated?
      # try to login invalid activataion
      get edit_account_activation_path("invalid token", email: user.email)
      assert_not logged_in?
      # try to login wrong email
      get edit_account_activation_path(user.activation_token, email: 'wrong')
      assert_not logged_in?
      # try to login valid activation token
      get edit_account_activation_path(user.activation_token, email: user.email)
      assert user.reload.activated?
      follow_redirect!
      assert_template 'users/show'
      assert logged_in?
    end

  test "valid information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user:{ name:"  ", email:"next@next", password:"pass", password_confirmation:"word"} }
    end
    assert_template 'users/new'
    assert_select 'div.error_explanation'
  end

  # test "valid signup information" do
  #   get signup_path
  #   assert_difference 'User.count' do
  #     post users_path, params: { user:{ name:"Some One", email:"next@next.com", password:"pass1234", password_confirmation:"pass1234"} }
  #   end
  #   follow_redirect!
  #   assert_template 'users/show'
  #   assert_not flash.empty?
  # end
end

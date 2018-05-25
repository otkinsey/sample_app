require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "valid information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user:{ name:"  ", email:"next@next", password:"pass", password_confirmation:"word"} }
    end
    assert_template 'users/new'
    assert_select 'div.error_explanation'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count' do
      post users_path, params: { user:{ name:"Some One", email:"next@next.com", password:"pass1234", password_confirmation:"pass1234"} }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end
end

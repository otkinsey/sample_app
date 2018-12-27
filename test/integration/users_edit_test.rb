require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:okoa)
  end

  test 'unsuccessful edit' do
    get edit_user_path(@user)
    puts "[test/integration/users_edit_test.rb: unsuccessful edit] edit_user_path: #{edit_user_path(@user)} \n\n "
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                              email: "foo@invalid",
                                              password: "",
                                              password_confirmation: "" }}
    assert_template 'users/edit'
    assert_select "div.alert", text: "the form contains 2 errors"
  end

  test 'test successful edit' do
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name,
                                                   email: email,
                                                   password: "komet1",
                                                   password_confirmation: "komet1" } }
    # assert_select "div.alert", text: "the form contains 4 errors"
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end

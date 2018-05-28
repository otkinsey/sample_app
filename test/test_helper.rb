ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__ )
require 'rails/test_help'
require 'minitest/reporters'

Minitest::Reporters.use!



class ActiveSupport::TestCase

  fixtures :all
  include ApplicationHelper

  def log_in_as(user)
    session[:user_id] = user.id
  end

  def is_logged_in?
    !session[:user_id].nil?
  end

end

class ActionDispatch::IntegrationTest

  def log_in_as(user, password: 'komet1234', remember_me: '1') #login mechanism is flawed here
    post login_path, params: { session: { email: user.email, password: password, remember_me: remember_me } }
  end
  # Add more helper methods to be used by all tests here...
end

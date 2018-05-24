require 'test_helper'

class ApplicationHeplerTest < ActionView::TestCase
  test 'Full Title Helper' do
    assert_equal full_title, "Rails app"
    assert_equal full_title("Help"), "Help | Rails app"
  end
end

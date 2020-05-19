require 'test_helper'

class MoviesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get movies_show_url
    assert_response :success
  end

end

require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest

  test "should get root" do
    get root_path
    #get root_url
    assert_response :success
    assert_select "title", "Yuritter"
  end

  test "should get about" do
    get about_path
    #get about_url
    assert_response :success
    assert_select "title", "About | Yuritter"
  end

end

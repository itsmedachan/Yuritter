require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "layout links" do
    get root_path
    assert_template 'home/top'#, count:2
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", signup_path
    # assert_select "a[href=?]", login_path

    get about_path
    assert_select "title", full_title("About")

    get signup_path
    assert_select "title", full_title("Sign up")

    get login_path
    assert_select "title", full_title("Log in")

  end
end

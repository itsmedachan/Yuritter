require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,            "Yuritter"
    assert_equal full_title("About"),   "About | Yuritter"
    assert_equal full_title("Sign up"), "Sign up | Yuritter"
  end
end

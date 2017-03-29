require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  test "should get login" do
    get :login
    assert_response :success
  end

end

require 'test_helper'

class AssetsControllerTest < ActionController::TestCase
  test "should get asset_list" do
    get :asset_list
    assert_response :success
  end

end

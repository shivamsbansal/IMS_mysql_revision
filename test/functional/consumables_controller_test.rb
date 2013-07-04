require 'test_helper'

class ConsumablesControllerTest < ActionController::TestCase
  test "should get consumable_issue" do
    get :consumable_issue
    assert_response :success
  end

end

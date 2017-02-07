require 'test_helper'

class JobsControllerTest < ActionController::TestCase
  test "should get annotate" do
    get :annotate
    assert_response :success
  end

end

require 'test_helper'

class SubmissionControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end

require 'test_helper'

class CallNotesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:rhys)
    log_in_as(@admin)
  end

  test "should get index" do
    get new_call_note_path
    assert_response :success
  end

end

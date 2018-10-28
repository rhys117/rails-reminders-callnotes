require 'test_helper'

class CallNotesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get call_notes_url
    assert_response :success
  end

  test "should get new" do
    get new_call_note_url
    assert_response :success
  end
end

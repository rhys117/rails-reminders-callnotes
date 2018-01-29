require 'test_helper'

class CallNotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @call_note = call_notes(:one)
  end

  test "should get index" do
    get call_notes_url
    assert_response :success
  end

  test "should get new" do
    get new_call_note_url
    assert_response :success
  end

  test "should create call_note" do
    assert_difference('CallNote.count') do
      post call_notes_url, params: { call_note: { : @call_note., belongs_to: @call_note.belongs_to, name: @call_note.name, time: @call_note.time } }
    end

    assert_redirected_to call_note_url(CallNote.last)
  end

  test "should show call_note" do
    get call_note_url(@call_note)
    assert_response :success
  end

  test "should get edit" do
    get edit_call_note_url(@call_note)
    assert_response :success
  end

  test "should update call_note" do
    patch call_note_url(@call_note), params: { call_note: { : @call_note., belongs_to: @call_note.belongs_to, name: @call_note.name, time: @call_note.time } }
    assert_redirected_to call_note_url(@call_note)
  end

  test "should destroy call_note" do
    assert_difference('CallNote.count', -1) do
      delete call_note_url(@call_note)
    end

    assert_redirected_to call_notes_url
  end
end

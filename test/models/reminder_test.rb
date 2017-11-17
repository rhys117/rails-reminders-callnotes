require 'test_helper'

class ReminderTest < ActiveSupport::TestCase

  def setup
    @user = users(:rhys)
    @reminder = @user.reminders.build(date: Date.today, reference: "4044217",
                                     vocus_ticket: "322204", nbn_search: "INC000005717907",
                                     service_type: "FTTN", priority: 5,
                                     complete: false, notes: "OFFLINE | Contact? Usage?",
                                     vocus: false)
  end

  test "should be valid" do
    assert @reminder.valid?
  end

  test "user id should be present" do
    @reminder.user_id = nil
    assert_not @reminder.valid?
  end

  test "reference should be present" do
    @reminder.reference = '   '
    assert_not @reminder.valid?
  end

  test "notes should be present" do
    @reminder.notes = '    '
    assert_not @reminder.valid?
  end

  test "date should be present" do
    @reminder.date = nil
    assert_not @reminder.valid?
  end

  test "service type should be present" do
    @reminder.service_type = '    '
    assert_not @reminder.valid?
  end

  test "priority should be present" do
    @reminder.priority = nil
    assert_not @reminder.valid?
  end

  test "complete should be present" do
    @reminder.complete = nil
    assert_not @reminder.valid?
  end
end

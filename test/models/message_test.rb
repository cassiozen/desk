require 'test_helper'

class MessageTest < ActiveSupport::TestCase

  # The unread gem is already tested, but since messages
  # are in a polymorphic and indirect association with issues
  # I felt like testing for my specific scenario

  test "user should have unread messages" do
    Tenant.current_id = tenants(:codify).id
    assert_equal 5, issues(:one).messages.unread_by(users(:john)).count
  end

  test "user should mark messages as read" do
    Tenant.current_id = tenants(:codify).id
    Message.mark_array_as_read issues(:one).messages, users(:john)
    assert_equal 0, issues(:one).messages.unread_by(users(:john)).count
  end

end

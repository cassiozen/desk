require 'test_helper'

class InteractionTest < ActiveSupport::TestCase
  def setup
    Tenant.current_id = tenants(:codify).id
    @issue = Issue.create({
      tenant: tenants(:codify),
      requestor: requestor_profiles(:john),
      assignee: assignee_profiles(:anna),
    })
  end

  def teardown
    @issue = nil
  end

  test "should create messages as interactions" do
    message = Message.new({body:"Loren ipsum dolor sit amet"})
    @issue.interactions.create({interacteable: message})
    assert_equal 1, @issue.interactions.count
    assert_equal "Message", @issue.interactions.first.interacteable_type
  end

  test "should create issue_states as interactions" do
    @issue.interactions.create({interacteable: @issue.change_state("closed")})
    assert_equal 1, @issue.interactions.count
    assert_equal "IssueState", @issue.interactions.first.interacteable_type
  end

  test "shouldn't create issue_state interaction if state transition is invalid" do
    assert @issue.open?
    @issue.interactions.create({interacteable: @issue.change_state("open")})
    assert_equal 0, @issue.interactions.count
  end

end
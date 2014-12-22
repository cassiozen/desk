require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  def setup
    Tenant.current_id = tenants(:codify).id
  end

  def teardown
    Tenant.current_id = nil
  end

  test "is open after create" do
    issue = Issue.create!
    assert issue.open?
  end

  test "can transition from open to pending state" do
    issue = Issue.create!
    issue.change_state("pending")
    assert issue.pending?
  end

  test "can transition from open to closed state" do
    issue = Issue.create!
    issue.change_state("closed")
    assert issue.closed?
  end

  test "can be reopened" do
    issue = Issue.create!
    issue.change_state("closed")
    assert issue.closed?
    issue.change_state("open")
    assert issue.open?
  end

  test "can't transition to unexisting states" do
    issue = Issue.create!
    assert_raises(ArgumentError) { issue.change_state("bazinga") }
  end

  test "Don't register a new state change transition when trying to change to same state" do
    issue = Issue.create!
    prev_issuestates = IssueState.count
    issue.change_state("open")
    assert_equal prev_issuestates, IssueState.count
  end

  test "should list all open issues" do
    assert_equal 1, Issue.open.count
  end

  test "should list all pending issues" do
    assert_equal 1, Issue.pending.count
  end

  test "should list all closed issues" do
    assert_equal 3, Issue.closed.count
  end

  test "should list all overdue issues" do
    assert_equal 2, Issue.overdue.count
  end

  test "should list all issues for today" do
    assert_equal 1, Issue.due_today.count
  end
end
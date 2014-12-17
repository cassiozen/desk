require 'test_helper'

class RequestTest < ActiveSupport::TestCase

  test "is open after create" do
    req = Request.create!
    assert req.open?
  end

  test "can transition from open to pending state" do
    req = Request.create!
    req.change_state("pending")
    assert req.pending?
  end

  test "can transition from open to closed state" do
    req = Request.create!
    req.change_state("closed")
    assert req.closed?
  end

  test "can be reopened" do
    req = Request.create!
    req.change_state("closed")
    assert req.closed?
    req.change_state("open")
    assert req.open?
  end

  test "can't transition to unexisting states" do
    req = Request.create!
    assert_raises(ArgumentError) { req.change_state("bazinga") }
  end

  test "Don't register a new state change transition when trying to change to same state" do
    req = Request.create!
    prev_reqstates = RequestState.count
    req.change_state("open")
    assert_equal prev_reqstates, RequestState.count
  end

  test "should list all open requests" do
    assert_equal 1, Request.open_requests.count
  end

  test "should list all pending requests" do
    assert_equal 1, Request.pending_requests.count
  end

  test "should list all closed requests" do
    assert_equal 3, Request.closed_requests.count
  end
end
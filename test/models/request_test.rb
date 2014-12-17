require 'test_helper'

class RequestTest < ActiveSupport::TestCase

  test "is open after create" do
    req = Request.create!
    assert req.open?
  end

  test "can transition from open to pending state" do
    req = Request.create!
    req.pend
    assert req.pending?
  end

  test "can transition from open to closed state" do
    req = Request.create!
    req.close
    assert req.closed?
  end

  test "can transition from pending to closed state" do
    req = Request.create!
    req.pend
    assert req.pending?
    req.close
    assert req.closed?
  end

  test "can be reopened" do
    req = Request.create!
    req.close
    assert req.closed?
    req.reopen
    assert req.open?
  end

  test "can't go from closed to pending" do
    req = Request.create!
    req.close
    assert req.closed?
    req.pend
    assert !req.pending?
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
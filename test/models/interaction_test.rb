require 'test_helper'

class InteractionTest < ActiveSupport::TestCase
  def setup
    @request = Request.create({
      portal: portals(:codify),
      requestor: requestor_profiles(:john),
      assignee: assignee_profiles(:anna),
    })
  end

  def teardown
    @request = nil
  end

  test "should create messages as interactions" do
    message = Message.new({body:"Loren ipsum dolor sit amet"})
    @request.interactions.create({interacteable: message})
    assert_equal 1, @request.interactions.count
    assert_equal "Message", @request.interactions.first.interacteable_type
  end

  test "should create request_states as interactions" do
    @request.interactions.create({interacteable: @request.change_state("closed")})
    assert_equal 1, @request.interactions.count
    assert_equal "RequestState", @request.interactions.first.interacteable_type
  end

  test "shouldn't create request_state interaction if state transition is invalid" do
    assert @request.open?
    @request.interactions.create({interacteable: @request.change_state("open")})
    assert_equal 0, @request.interactions.count
  end

end
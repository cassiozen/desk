require 'test_helper'

class IssuesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def with_subdomain(subdomain)
    @request.host  = "#{subdomain}.example.dev"
  end

  test "should return no records if no tenant (subdomain) is provided" do
    assert_raises(ActiveRecord::RecordNotFound) do
      get :index, :format => :json
    end
  end

  test "should return no records if no user is logged in" do
    with_subdomain tenants(:codify).subdomain
    get :index, :format => :json
    assert_response(403)
  end

  test "Requestor user can only see the issues he created" do
    Tenant.current_id = tenants(:codify).id
    sign_in users(:john)
    with_subdomain tenants(:codify).subdomain
    get :index, :format => :json
    body = JSON.parse(response.body)
    assert_equal 2, body.count
  end

  test "Assignee user can see all issues" do
    Tenant.current_id = tenants(:codify).id
    sign_in users(:george)
    with_subdomain tenants(:codify).subdomain
    get :index, :format => :json
    body = JSON.parse(response.body)
    assert_equal 5, body.count
  end
end


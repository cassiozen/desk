class IssuesController < ApplicationController
  load_and_authorize_resource

  def index
    # Load and authorize already creates @issues variable
    # but i'm reassigning it here to eager load (includes)
    @issues = @issues.includes(:assignee, :requestor)
  end
end

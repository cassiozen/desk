class IssuesController < ApplicationController
  load_and_authorize_resource

  def index
    # "Load and authorize resource" already creates @issues variable
    # but i'm reassigning it here to eager load (includes)
    @issues = @issues.includes(:assignee, :requestor)
    if request.headers['X-PJAX']
      render :layout => false
    end
  end

  def show
    @interaction = Interaction.new

    if request.headers['X-PJAX']
      render :layout => false
    end
  end
end

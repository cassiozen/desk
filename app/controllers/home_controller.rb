class HomeController < ApplicationController
  skip_filter :scope_current_tenant, :only => :index

  def index
    # No subdomain
  end

  def show
    # subdomain specific
  end
end

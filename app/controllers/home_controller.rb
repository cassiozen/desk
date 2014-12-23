class HomeController < ApplicationController
  skip_filter :scope_current_tenant, :only => :index

  def index
    # No subdomain
    if request.headers['X-PJAX']
      render :layout => false
    end
  end

  def show
    # subdomain specific
    if request.headers['X-PJAX']
      render :layout => false
    end
  end
end

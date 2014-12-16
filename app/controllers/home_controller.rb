class HomeController < ApplicationController
  before_filter :load_portal, :except => :index

  def index
  end

  def show

  end
end

class DashboardsController < ApplicationController
  def show
    @overdue = Issue.overdue.count
    @pending = Issue.pending.count
    @open    = Issue.open.count
    @today   = Issue.due_today.count
    @activities = PublicActivity::Activity.order("created_at desc")
  end
end

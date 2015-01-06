module IssuesHelper
  def issue_fa_icon(state)
    state_icons = {"pending" => "<i class='text-warning state fa fa-pause'></i>".html_safe, "open" => "<i class='text-green state fa fa-exclamation-circle'></i>".html_safe, "closed" => "<i class='text-alizarin state fa fa-check-circle-o'></i>".html_safe}
    state_icons[state]
  end

  def issue_fa_button(state)
    state_icons = {"pending" => "<div class='btn btn-warning pull-left'><i class='fa fa-pause'> On Hold</i></div>".html_safe, "open" => "<div class='btn btn-green pull-left'><i class='fa fa-exclamation-circle'> Open</i></div>".html_safe, "closed" => "<div class='btn btn-alizarin pull-left'><i class='fa fa-check-circle-o'> Closed</i></div>".html_safe}
    state_icons[state]
  end

  def humanized_due_date(date)
    return "Due today" if date.today?
    return "Due in #{time_ago_in_words(date)}" if date > DateTime.now
    return "Overdue by #{time_ago_in_words(date)}" if date < DateTime.now
  end

  def truncate_filename(name)
    name.truncate(30, omission: "...#{name.last(15)}")

  end
end

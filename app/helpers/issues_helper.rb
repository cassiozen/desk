module IssuesHelper
  def issue_fa_icon(state)
    state_icons = {"overdue" => "<i class='text-alizarin state fa fa-exclamation-triangle'></i>".html_safe, "pending" => "<i class='text-inverse state fa fa-pause'></i>".html_safe, "open" => "<i class='text-blue state fa fa-clock-o'></i>".html_safe, "due_today" => "<i class='text-midnightblue state fa fa-calendar-o'></i>".html_safe, "closed" => "<i class='text-green state fa fa-check-circle-o'></i>".html_safe}
    state_icons[state]
  end

  def humanized_due_date(date)
    return "Due today" if date.today?
    return "Due in #{time_ago_in_words(date)}" if date > DateTime.now
    return "Overdue by #{time_ago_in_words(date)}" if date < DateTime.now
  end
end

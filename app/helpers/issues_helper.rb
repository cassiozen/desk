module IssuesHelper
  def issue_fa_icon(state, date)
    color = ""
    if date.today?
      color = 'midnightgreen'
    elsif date > DateTime.now
      color = 'green'
    elsif date < DateTime.now
      color = 'alizarin'
    end
    state_icons = {"pending" => "<i class='text-warning state fa fa-pause'></i>".html_safe, "open" => "<i class='text-#{color} state fa fa-exclamation-triangle'></i>".html_safe, "closed" => "<i class='text-inverse state fa fa-check-circle-o'></i>".html_safe}
    state_icons[state]
  end

  def humanized_due_date(date)
    return "Due today" if date.today?
    return "Due in #{time_ago_in_words(date)}" if date > DateTime.now
    return "Overdue by #{time_ago_in_words(date)}" if date < DateTime.now
  end
end

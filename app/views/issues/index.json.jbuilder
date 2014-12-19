json.array!(@issues) do |issue|
  json.extract! issue, :id, :due_in
  json.requestor issue.requestor.user.try(:name)
  json.assignee issue.assignee.user.try(:name)
end
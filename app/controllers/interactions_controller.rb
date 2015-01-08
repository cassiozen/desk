class InteractionsController < ApplicationController
  def create
    issue = Issue.find(params[:issue_id])
    messageParam = params[:body]
    interaction_type_param = params[:interaction_type]
    attachment_ids = params[:attachment_ids]


    # Create message interaction if there's a message body
    if not messageParam.empty?
      messageInteraction = Interaction.new({issue: issue, user: current_user})
      message = Message.new({body: messageParam})
      if(attachment_ids)
        message.attachments.push(*Attachment.find(attachment_ids))
      end
      messageInteraction.interacteable = message
      messageSaved = messageInteraction.save
    end

    # Create an issue state interaction if there's an issue state param
    if (interaction_type_param == "open" and not issue.open?) or (interaction_type_param == "closed" and not issue.closed?) or (interaction_type_param == "pending" and not issue.pending?)
      stateInteraction = Interaction.new({issue: issue, user: current_user})
      state = IssueState.new({issue: issue, state: interaction_type_param})
      stateInteraction.interacteable = state
      stateInteraction.save
      stateSaved = stateInteraction.save
    end

    # Check if the interactions are either nil (no interaction param) or saved (in the case of an interaction param)
    if ((messageSaved.nil? or messageSaved == true) and (stateSaved.nil? or stateSaved == true))
      redirect_to issue
    else
      raise "Error when creating interactions"
    end
  end
end

class CommentsController < ApplicationController
  before_action :set_event, only: [:create, :destroy]
  before_action :set_comment, only: [:destroy]

  def create
    @new_comment = @event.comments.build(comment_params)
    @new_comment.user = current_user

    if @new_comment.save
      # notify all subscribers of a new comment
      notify_subscribers(@event, @new_comment)
      redirect_to @event, notice: I18n.t('controllers.comments.created')
    else
      render 'events/show', alert: I18n.t('controllers.comments.error')
    end
  end

  def destroy
    message = {notice: I18n.t('controllers.comments.destroyed')}

    if current_user_can_edit?(@comment)
      @comment.destroy!
    else
      message = {alert: I18n.t('controllers.comments.error')}
    end

    redirect_to @event, message
  end

  private

  def notify_subscribers(event, comment)
    # Collect all subscribers and the author of the event into an array of mails, exclude duplicate
    all_emails = (event.subscriptions.map(&:user_email) + [event.user.email]-[comment&.user&.email]).uniq

    # We send mailings to addresses from this array
    # As in subscriptions, take EventMailer and its comment method with parameters
    # And send in the same stream
    all_emails.each do |mail|
      #EventMailer.comment(event, comment, mail).deliver_later
      MailDeliveryJob.perform_later(event, comment, mail)
    end
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_comment
    @comment = @event.comments.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def comment_params
    params.require(:comment).permit(:body, :user_name)
  end
end

class EventMailer < ApplicationMailer

  def subscription(event, subscription)
    @email = subscription.user_email
    @name = subscription.user_name
    @event = event

    # We take from the user his email
    # Subject can also be migrated to locales
    mail to: event.user.email, subject: "#{I18n.t('subscriptions.subscription.new_subscription')} #{event.title}"
  end

  def comment(event, comment, email)
    @comment = comment
    @event = event

    mail to: email, subject: "#{I18n.t('comments.comment.new_comment')} #{event.title}"
  end
end

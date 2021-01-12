class MailDeliveryJob < ApplicationJob
  queue_as :default

  def perform(entity)
    event = entity.event
    all_emails = (event.subscriptions.map(&:user_email) + [event.user.email] - [entity.user&.email]).uniq

    case entity
    when Comment
      all_emails.each { |mail| EventMailer.comment(event, entity, mail).deliver_later }
    when Photo
      all_emails.each { |mail| EventMailer.photo(event, entity, mail).deliver_later }
    when Subscription
      EventMailer.subscription(event, entity).deliver_later
    end
  end
end

class MailDeliveryJob < ApplicationJob
  queue_as :default

  def perform(event, entity)
    name_of_entity = entity.class.to_s
    all_emails = (event.subscriptions.map(&:user_email) + [event.user.email] - [entity&.user&.email]).uniq

    case name_of_entity
    when "Comment"
      all_emails.each { |mail| EventMailer.comment(event, entity, mail).deliver_later }
    when "Photo"
      all_emails.each { |mail| EventMailer.photo(event, entity, mail).deliver_later }
    when "Subscription"
      EventMailer.subscription(event, entity).deliver_later
    end
  end
end

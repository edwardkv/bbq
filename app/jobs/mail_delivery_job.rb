class MailDeliveryJob < ApplicationJob
  queue_as :default

  def perform(event, entity, mail='')
    name_of_entity = entity.class.to_s

    if name_of_entity == "Comment"
      EventMailer.comment(event, entity, mail).deliver_later
    elsif name_of_entity == "Photo"
      EventMailer.photo(event, entity, mail).deliver_later
    elsif name_of_entity == "Subscription"
      EventMailer.subscription(event, entity).deliver_later
    end
  end
end

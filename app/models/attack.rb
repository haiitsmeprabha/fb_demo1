class Attack < ActiveRecord::Base

  after_create :send_attack_notification

  def send_attack_notification
    AttackPublisher.deliver_attack_notification_email(self)
    AttackPublisher.deliver_profile_update(attacking_user)
    AttackPublisher.deliver_profile_update(defending_user)
  rescue Facebooker::Session::SessionExpired
# We can't recover from this error, but
# we don't want to show an error to our user
  end

  belongs_to :attacking_user,
             :class_name=>"User",
             :foreign_key=>:attacking_user_id
  belongs_to :defending_user,
             :class_name=>"User",
             :foreign_key=>:defending_user_id
  belongs_to :move


end

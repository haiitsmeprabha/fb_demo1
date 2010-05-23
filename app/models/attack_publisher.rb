class AttackPublisher < Facebooker::Rails::Publisher
  helper :application

  def attack_notification_email(attack)
    send_as :email
    recipients attack.defending_user
    from attack.attacking_user.facebook_session.user
    title "You've been attacked!"
    fbml render(:partial => "attacks/email_msg", :assigns => {:attack => attack})
  end

  def profile_update(user)
    send_as :profile
    recipients user.facebook_session.user
    @battles=user.battles
    profile render(:partial=>"attacks/profile", :assigns=>{:battles=>@battles, :user => user})
    profile_main "hey i will be coming in the main profile page"
  end
end

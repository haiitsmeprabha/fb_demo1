class User < ActiveRecord::Base
  has_many :attacks, :foreign_key=>:attacking_user_id
  has_many :defenses, :class_name=>"Attack",
           :foreign_key=>:defending_user_id

  def attack(other_user, move)
    attacks << Attack.new(:move => move, :defending_user => other_user)
  end

  def battles
    Attack.find(:all,
                :conditions=>
                        ["attacking_user_id=? or defending_user_id=?",
                         self.id, self.id],
                :include=>[:attacking_user, :defending_user, :move],
                :order=>"attacks.created_at desc")
  end

  def self.for(facebook_id, facebook_session=nil)
    returning find_or_create_by_facebook_id(facebook_id) do |user|
      unless facebook_session.nil?
        user.store_session(facebook_session.session_key)
      end
    end
  end


  def facebook_session
    @facebook_session ||=
            returning Facebooker::Session.create do |session|
              # Facebook sessions are good for only one hour after storing
              session.secure_with!(session_key, facebook_id, 1.hour.from_now)
            end
  end

  def store_session(session_key)
    if self.session_key != session_key
      update_attribute(:session_key, session_key)
    end
  end
end

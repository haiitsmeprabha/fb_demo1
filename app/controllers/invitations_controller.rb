class InvitationsController < ApplicationController

  def new
    if params[:from]
      @user = facebook_session.user
      @user.profile_fbml =
              "<fb:fbml>
                      <a href='"+
                      new_invitation_url(:from=>@user.to_s, :canvas=>true)+
                      "'>Attack your friends, install Karate Poke</a>" +
                      "<br />I was sent here by " +
                      "<fb:name uid='#{params[:from]}' /></fb:fbml>"


    end
    @from_user_id = facebook_session.user.to_s
  end

  def index
    redirect_to attacks_path
  end

  def create
    @sent_to_ids = params[:ids]
  end
end

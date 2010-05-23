class AttacksController < ApplicationController
  skip_before_filter :ensure_authenticated_to_facebook, :only => [:tab]
  def new
  end

  def create
    attack = Attack.new(params[:attack])
    for id in params[:ids]
      current_user.attack(User.for(id), attack.move)
      flash.now[:notice] = "You have attacked successfully"
    end
    redirect_to new_attack_path
  end

  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end
    @battles = @user.battles
    if @battles.blank?
      flash.now[:notice]="You haven't battled anyone yet." +
              " Why don't you attack your friends?"
      redirect_to new_attack_path
    end
  end

  def tab
    @user = User.for(params[:fb_sig_profile_user])
    @battles = @user.battles
    render(:partial => "tabProfile", :assigns => {:user => @user, :battles => @battles})
  end
end


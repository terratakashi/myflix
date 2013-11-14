class InvitationsController < ApplicationController
  before_action :require_user
  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new( secure_params.merge!(inviter: current_user) )
    if @invitation.save
      MyflixMailer.invitation_mail(@invitation).deliver
      flash[:notice] = "An invitation has been sent to #{@invitation.recipient_name}."
      redirect_to invite_path
    else
      flash[:error] = "Error. Please check your input."
      render :new
    end
  end

  private

  def secure_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message)
  end
end

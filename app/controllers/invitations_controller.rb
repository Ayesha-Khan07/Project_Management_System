class InvitationsController < ApplicationController
    before_action :set_project

    def new
        @invitation = @project.invitations.new
    end

   def create
    @invitation = @project.invitations.new(invitation_params)
    @invitation.expires_at = 24.hours.from_now
    @invitation.used = false

    respond_to do |format|
        if @invitation.save
        InvitationMailer.invite_user(@invitation).deliver_later
        format.json { render json: { success: true } }
        format.html { redirect_to project_path(@project), notice: "Invitation sent!" }
        else
        format.json { render json: { errors: @invitation.errors.full_messages }, status: :unprocessable_entity }
        format.html { redirect_to project_path(@project), alert: "Failed to send invitation." }
        end
     end
   end


    private

    def set_project
        @project = Project.find(params[:project_id])
    end

    def invitation_params
        params.require(:invitation).permit(:email, :role)
    end

end
class InvitationMailer < ApplicationMailer
    default from: "no-reply@project_hub.com"

    def invite_user(invitation)
        @invitation = invitation
        @url = accept_invite_url(token: @invitation.token)
        mail(
            to: @invitation.email,
            subject: "You are invited to joing #{invitation.project.title}"
        )
    end
end

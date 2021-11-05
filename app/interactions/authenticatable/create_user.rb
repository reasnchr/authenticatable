module Authenticatable
	class CreateUser < ActiveInteraction::Base
		import_filters AuthorizeUser, except: :subject

		# Place specific registration fields here
		string :email, default: nil

		# Place specific validations here
		validates :email, presence: true, if: -> { provider_type == 'Email' }

		def execute
			@user = User.where( auth_user_id: auth_user_id ).first
			return shadow_authorize if @user

			# Change user initialization here if it is needed
			@user = User.new auth_user_id: auth_user_id, email: email

			shadow_authorize
			errors.merge! @user.errors if errors.blank? && !@user.save

			@user
		end

		private

		def shadow_authorize
			subject = AuthorizeUser.run inputs.merge! subject: @user
			subject.errors.messages.each{ |key, value| errors.add key, value }
			@user
		end
	end
end

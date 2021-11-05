module Authenticatable
	class AuthorizeUser < ActiveInteraction::Base
		object :subject, class: :User, default: nil

		# Place specific authorization fields here
		integer :auth_user_id
		string :provider_type

		# Place specific validations here
		validates :provider_type, inclusion: { in: Authenticatable.config.providers }

		def execute
			@user = subject || User.where( auth_user_id: auth_user_id ).first
			return errors.add :user, 'unauthorized' unless @user

			validate_user
		end

		private

		def validate_user
			# Place specific authorization logic here if it is needed
			# and uncomment next line
			# return errors.add :user, 'unauthorized' unless @user.valid?

			@user
		end
	end
end

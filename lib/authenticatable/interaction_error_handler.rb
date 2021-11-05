module Authenticatable
	module InteractionErrorHandler
		extend ActiveSupport::Concern

		included do
			rescue_from Authenticatable::UserCreatingError, with: :invalid_user_error
			rescue_from Authenticatable::UserAuthorizationError, with: :invalid_user_error
		end

		private

		def invalid_user_error interaction_errors
			Rails.logger.info{ "#{ interaction_errors.class }: #{ interaction_errors.message }" }
			Rails.logger.info{ "\t" + interaction_errors.backtrace[ 0, 10 ].join( "\n\t" ) }

			errors = @interaction.errors.messages.keys.map{ |key| { key: key, message: @interaction.errors.messages[ key ].join( ", " ) } }
			render json: { success: false, errors: errors }, status: 422
		end
	end
end

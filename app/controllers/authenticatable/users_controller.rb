module Authenticatable
	class UsersController < ActionController::API
		include InteractionErrorHandler

		before_action :parse_jwt

		def create
			@interaction = Authenticatable::CreateUser.run params
			fail Authenticatable::UserCreatingError, @interaction.errors.full_messages.join( ', ' ) unless @interaction.valid?
			render json: { success: true }
		end

		def authorize
			@interaction = Authenticatable::AuthorizeUser.run params
			fail Authenticatable::UserAuthorizationError, @interaction.errors.full_messages.join( ', ' ) unless @interaction.valid?
			render json: { success: true }
		end

		private

		def parse_jwt
			data, header = JWT.decode params[ :data ], Authenticatable::JWT_KEY, true, { algorithm: 'HS256' }
			payload = data.delete 'payload'

			params.delete :data
			params.reverse_merge! data
			params.reverse_merge! payload if payload

			logger.info{ "  Decoded parameters: #{ params }" }
		rescue JWT::DecodeError
			render json: { success: false, errors: [ :invalid_cross_service_token ] }, status: :unauthorized
		end
	end
end

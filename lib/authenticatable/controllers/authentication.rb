module Authenticatable
	module Controllers
		module Authentication
			extend ActiveSupport::Concern

			included { before_action :check_session }

			private

			attr_reader :current_user_id

			def check_session
				jwt = request.headers[ 'session-token' ]
				return unauthorized_error unless jwt

				payload, header = JWT.decode jwt, JWT_KEY, true, { algorithm: 'HS512' }
				@current_user_id = payload[ 'uid' ]
			rescue JWT::DecodeError
				unauthorized_error
			end

			def check_external_session
				auth_service_request = Net::HTTP::Get.new '/session'
				auth_service_request[ 'session-token' ] = request.headers[ 'session-token' ]

				response = Authenticatable.config.http.request auth_service_request
				return internal_auth_service_error if response.code.to_i == 500

				json = JSON.parse response.body
				return unauthorized_error if json[ 'error' ].present?

				@current_user_id = json[ 'user_id' ]
			end

			def current_user
				return unless @current_user_id
				@current_user ||= User.where( auth_user_id: @current_user_id ).first
			end

			def unauthorized_error
				render json: Authenticatable.config.unauthorized_error.call, status: :unauthorized
			end

			def internal_auth_service_error
				render json: { success: false, errors: [ :internal_auth_service_error ] }, status: :internal_server_error
			end
		end
	end
end

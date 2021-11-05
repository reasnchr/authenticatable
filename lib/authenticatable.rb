require 'active_interaction'
require 'jwt'
require 'net/http'

require 'authenticatable/config'
require 'authenticatable/version'

module Authenticatable
	class Engine < Rails::Engine; end

	module Controllers
		autoload :Authentication, 'authenticatable/controllers/authentication'
	end

	autoload :UserCreatingError, 'authenticatable/user_creating_error'
	autoload :UserAuthorizationError, 'authenticatable/user_authorization_error'
	autoload :InteractionErrorHandler, 'authenticatable/interaction_error_handler'

	JWT_KEY = ENV.fetch 'SECRET_JWT_KEY'

	class << self
		def configure
			yield config
		end

		def call action, params = {}
			data = JWT.encode params || {}, JWT_KEY, 'HS512'
			uri = "/p2p/#{ action }"

			request = Net::HTTP::Post.new uri, 'Content-Type' => 'application/json'
			request.body = %Q[{"data":"#{ data }"}]

			Rails.logger.debug{ "Send request to auth service:" }
			Rails.logger.debug{ "POST #{ uri }" }
			response = config.http.request request
			Rails.logger.debug{ "Status: #{ response.code }; body: #{ response.body }" }

			JSON.parse response.body
		end
	end

	cattr_accessor :config

	self.config = Config.new
end

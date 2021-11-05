module Authenticatable
	class Config
		attr_writer :url, :unauthorized_error

		def url
			@url ||= ENV.fetch 'AUTH_SERVICE_URL'
		end

		def unauthorized_error
			@unauthorized_error ||= -> { { success: false, errors: [ :unauthorized ] } }
		end

		def providers
			@providers ||= JSON.parse( Net::HTTP.get URI( "#{ url }/providers" ) ).freeze
		end

		def http
			@http ||= begin
				uri = URI url
				Net::HTTP.new uri.host, uri.port
			end
		end
	end
end

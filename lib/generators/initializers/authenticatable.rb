Authenticatable.configure do | config |
	# Configure auth service url
	config.url = ENV.fetch 'AUTH_SERVICE_URL'
end

$LOAD_PATH.push File.expand_path( 'lib', __dir__ )

require 'authenticatable/version'

Gem::Specification.new do |spec|
	spec.name = 'authenticatable'
	spec.version = Authenticatable::VERSION
	spec.date = '2019-03-26'

	spec.authors = %w[ SlayerShadow ]
	spec.email = %w[ gawfast@gmail.com ]

	spec.summary = 'Authentcation module to communicate with auth service'
	spec.description = 'Authentcation module to communicate with auth service'
	spec.license = 'MIT'

	spec.files = Dir[ '{app,config,lib}/**/*.rb' ]

	spec.add_dependency 'rails'
	spec.add_dependency 'active_interaction'
	spec.add_dependency 'jwt'
end

require 'rails/generators/migration'

module Authenticatable
	module Generators
		class AuthenticatableGenerator < Rails::Generators::Base
			include Rails::Generators::Migration

			@@previous_migration_number = Time.now.utc.strftime( '%Y%m%d%H%M%S' ).to_i

			source_root File.expand_path( 'templates', __dir__ )

			desc 'Creates required files for the user authentication.'

			def self.next_migration_number path
				( @@previous_migration_number += 1 ).to_s
			end

			def copy_authenticatable_files
				migration_template 'migration_create_users.rb', 'db/migrate/create_users.rb'
				copy_file './initializers/authenticatable.rb', 'app/config/initializers/authenticatable.rb'
				copy_file '../../../app/interactions/authenticatable/create_user.rb', 'app/interactions/authenticatable/create_user.rb'
				copy_file '../../../app/interactions/authenticatable/authorize_user.rb', 'app/interactions/authenticatable/authorize_user.rb'
				copy_file '../../../app/models/user.rb', 'app/models/user.rb'
			end
		end
	end
end

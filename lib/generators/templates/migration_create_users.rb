class CreateUsers < ActiveRecord::Migration[ 5.2 ]
	def change
		create_table :users do |t|
			t.bigint :auth_user_id, null: false, index: { unique: true }
			t.string :email
			t.timestamps
		end
	end
end

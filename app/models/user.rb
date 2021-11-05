class User < ApplicationRecord
	validates :auth_user_id, presence: true, uniqueness: true
end

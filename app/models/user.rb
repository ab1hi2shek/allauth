class User < ApplicationRecord
has_many :posts
has_many :forums
has_many :comments

validates :name, :email, :provider, :uid, :roles, presence: true

  	enum roles: [
				:normal,
				:supervisor,
				:superuser
               ]

class << self
	$found_or_created=0;
	def create_with_omniauth(auth)
		uid=auth.uid
		info=auth.info.symbolize_keys!
		if User.exists?(uid: uid)
			user=User.find_by(uid: uid)
			$found_or_created=1
		else
			user=User.create(uid: uid)
			user.name=info.name+" "
			user.provider=auth.provider
			user.avatar=info.image
			user.email=info.email
			user.roles = 0
			$found_or_created=2
		end
		user.save!
		user	
	end

	def f_o_c
		return $found_or_created
	end
end

end
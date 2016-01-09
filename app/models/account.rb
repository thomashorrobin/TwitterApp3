class Account < ActiveRecord::Base
  has_many :followers
  has_many :followings
end

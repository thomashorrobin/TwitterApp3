class Account < ActiveRecord::Base
  has_many :followers
  has_many :followings
  belongs_to :party_affiliation
end

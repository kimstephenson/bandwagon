class Genre < ActiveRecord::Base
  has_many :genres_users
  has_many :users, through: :genres_users

  validates :name, uniqueness: true
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :urls

  FREE = 'freeuser@shortener.com'.freeze

  def self.free_user
    User.find_by(email: FREE)
  end
end

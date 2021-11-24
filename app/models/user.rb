class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar
  validates :email, :first_name, :last_name, :birth_date, :password, presence: true
  validates :email, uniqueness: true
  has_many :donations, dependent: :destroy
end

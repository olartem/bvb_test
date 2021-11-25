class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar
  validates :email, :first_name, :last_name, :birth_date, presence: true
  validates :email, uniqueness: true
  validates :password, presence: true, on: :create
  has_many :donations, dependent: :destroy

  def active_for_authentication?
    super && !is_deleted
  end

  def soft_delete
    update_attribute(:is_deleted, true)
  end
end

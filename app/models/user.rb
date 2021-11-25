class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  has_one_attached :avatar
  validates :email, :first_name, :last_name, :birth_date, :city, presence: true
  validates :email, uniqueness: true
  validates :password, presence: true, on: :create
  has_many :donations, dependent: :destroy

  def active_for_authentication?
    super && !is_deleted
  end

  def soft_delete
    update_attribute(:is_deleted, true)
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    # Не зовсім правильно, але щось краще я не зміг придумати
    unless user
        user = User.create(first_name: data['first_name'],
          email: data['email'],
          last_name: data['last_name'],
          birth_date: Time.now - 18.years,
          city: 'City',
          gender: 'TBD',
          password: Devise.friendly_token[0, 20]
        )
    end
    user
end
end

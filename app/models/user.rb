class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  has_one_attached :avatar
  validates :email, :first_name, :last_name, :birth_date, :city, :gender, presence: true
  validates :email, uniqueness: true
  validates :password, presence: true, on: :create
  has_many :donations, dependent: :destroy
  has_one :location, dependent: :destroy
  after_create :add_location
  after_update :update_location
  
  def admin_label
    (first_name+" "+last_name).upcase
  end

  def update_location
    if self.city
      if self.location
        self.location.update_attribute(:city, self.city)
      else
        Location.create(user: self, city: self.city)
      end
    end
  end
  def active_for_authentication?
    super && !is_deleted
  end

  def add_location
    if self.city
      Location.create(user: self, city: self.city)
    end
  end

  def soft_delete
    update_attribute(:is_deleted, true)
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    
    unless user
        user = User.new(first_name: data['first_name'],
          email: data['email'],
          last_name: data['last_name'],
        )
    end
    user
  end
end

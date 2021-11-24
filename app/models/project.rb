class Project < ApplicationRecord
  validates :name, :money_goal, :description, :end_date, presence: true
  has_many :donations, dependent: :destroy
  has_many_attached :images
end

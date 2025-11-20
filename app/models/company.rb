class Company < ApplicationRecord
  has_many :users, dependent: :destroy
   has_many :projects, dependent: :destroy
  has_one_attached :logo

  # validations
  validates :name, presence: true, uniqueness: true
  validates :member_limit, numericality: { only_integer: true, greater_than: 0 }
end

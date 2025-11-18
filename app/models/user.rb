class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company, optional: true

  ROLES = %W[admin manager employee client]

  def admin?
    role == "admin"
  end

  def manager?
    role == "manager"
  end

  def client?
    role == "client"
  end

  def employee?
    role == "employee"
  end
end

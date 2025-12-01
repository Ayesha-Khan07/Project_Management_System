class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company, optional: true
  belongs_to :project, optional: true

  #added for email check now
  REGEX_EMAIL = /\A[^@\s]+@[^@\s]+\z/

  ROLES = %W[admin manager employee client super_admin]

  def super_admin?
    role == "super_admin"
  end

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

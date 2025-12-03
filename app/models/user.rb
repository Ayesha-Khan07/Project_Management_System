class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company, optional: true
  belongs_to :project, optional: true

  #added for email check now
  REGEX_EMAIL = /\A[^@\s]+@[^@\s]+\z/

  #email validations 
  validates :email, format: { with: REGEX_EMAIL, message: "Invalid Email Format."}
  validates :email, length: {maximum: 50, message: "Too Long Email. (Max Allow 50 Characters)"}   #in form do not add chars more than 50

  # username validation (to resolve the unique index err)
  validates :username, uniqueness: { case_sensitive: false, message: "Username already taken" }

  ROLES = %W[admin manager employee client super_admin]

  #added the metaprogramming dynamically method definition
  ROLES.each do |type|
    define_method "#{type}?" do
      role == type
    end
  end

end

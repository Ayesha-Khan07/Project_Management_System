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

  #added the metaprogramming dynamically method definition
  
  ROLES.each do |type|
    define_method "#{type}?" do
      role == type
    end
  end

end

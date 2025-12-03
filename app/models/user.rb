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

  #   ROLE LEVEL ACCESS 

  #  super_admin: have all access. can see the total registered companies. registered users of the compannies, projects and tasks of the companies.
  #   the super admin user can add, delete, edit the users, projects and tasks from a company.
  #  admin:  have full access within the company. can update company profile, projects and tasks related to the projects. 
  #           Can view all the projects of the company. Add and invite the users in the project.
  #  manager: have access to the project level. can view all projects of the company. can update the project and tasks.
  #  employee: have the limited access within the project. Can't view all projects of the company.can't create and update the project. 
  #           emp can create, update and view all tasks of the project in which he/she is being added.
  #  client: have read only access of the project. can view the project and tasks but can't create or update them. 


end

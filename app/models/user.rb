class User < ApplicationRecord
  rolify
  has_person_name

  attribute :time_zone

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :trackable, :validatable

  has_many :table_options, dependent: :destroy

  validates :first_name, length: { minimum: 2, maximum: 40  }
  validates :last_name, length: { minimum: 2, maximum: 40  }
  validates :phone_number, length: { minimum: 4, maximum: 20  }
  validates :email, length: { minimum: 7, maximum: 100  }

  before_create :set_default_role, if: :new_record?
  # before_save :bypass_email_confirmation

  def bypass_email_confirmation # Needed to prevent error in UsersController < Admin::ApplicationController
  end

  private

  def name
    "#{first_name} #{last_name}"
  end

  def set_default_role
    if self.roles.any? == false
      self.add_role(:customer)
    end
  end


end

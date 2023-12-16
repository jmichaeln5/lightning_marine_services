class User < ApplicationRecord
  rolify
  has_person_name

  attribute :time_zone

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :trackable, :validatable

  has_many :table_options, dependent: :destroy

  validates :first_name, length: { minimum: 2, maximum: 30  }
  validates :last_name, length: { minimum: 2, maximum: 40  }
  validates :phone_number, length: { minimum: 4, maximum: 20  }
  validates :email, length: { minimum: 7, maximum: 100  }

  # before_save :bypass_email_confirmation
  after_create :assign_default_role

  def bypass_email_confirmation # Needed to prevent error in UsersController < Admin::ApplicationController
  end

  private
    def default_role
      :customer
    end

    def assign_default_role
      self.add_role(:customer) if self.roles.blank?
    end
end

class Role < ApplicationRecord
  has_and_belongs_to_many :users, :join_table => :users_roles

  belongs_to :resource,
             :polymorphic => true,
             :optional => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  # validates :name,
  #         inclusion: { in: ["normal", "admin", "staff", "customer"] },
  #         uniqueness: true


  def self.all_roles
    self.all.map { |role| role.name  }
  end

  def self.defined_roles
    self.generic_roles.map { |role| role.name  }
  end
  # def self.generic_roles
  #   customer = Role.where(name: 'customer').first
  #   staff = Role.where(name: 'staff').first
  #   admin = Role.where(name: 'admin').first
  #   return [customer, staff, admin]
  # end

  def self.generic_roles

    customer = Role.where(name: 'customer').present? ? Role.where(name: 'customer').first : Role.create(name: 'customer')

    staff = Role.where(name: 'staff').present? ? Role.where(name: 'staff').first : Role.create(name: 'staff')

    admin = Role.where(name: 'admin').present? ? Role.where(name: 'admin').first : Role.create(name: 'admin')


    admin = Role.where(name: 'admin').first

    return [customer, staff, admin]
  end

  scopify
end

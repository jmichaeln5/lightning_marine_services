class Role < ApplicationRecord
  scopify
  
  has_and_belongs_to_many :users, :join_table => :users_roles

  belongs_to :resource,
             :polymorphic => true,
             :optional => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  def self.all_roles
    self.all.map { |role| role.name }
  end

  def self.defined_roles
    self.generic_roles.map { |role| role.name  }
  end

  def self.generic_roles
    customer = Role.where(name: 'customer').first_or_create
    staff = Role.where(name: 'staff').first_or_create
    admin = Role.where(name: 'admin').first_or_create
    return [customer, staff, admin]
  end

end

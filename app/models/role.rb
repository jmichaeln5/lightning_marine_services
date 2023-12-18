# == Schema Information
#
# Table name: roles
#
#  id            :bigint           not null, primary key
#  name          :string
#  resource_type :string
#  resource_id   :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Role < ApplicationRecord
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
    [Role.where(name: 'admin').first_or_create, Role.where(name: 'staff').first_or_create, Role.where(name: 'customer').first_or_create]
  end

  delegate :generic_roles, to: :class
  scopify # must be on last line of class
end

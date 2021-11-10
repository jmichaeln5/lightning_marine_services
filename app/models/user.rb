class User < ApplicationRecord
  rolify
  has_person_name
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :trackable, :validatable

  has_many :table_options

  validates :first_name, :last_name, :phone_number, presence: true, length: { minimum: 2, maximum: 30 }
  validates :email, presence: true, length: { minimum: 8, maximum: 100 }

  validates :username, :email, uniqueness: true

  before_create :set_default_role, if: :new_record?

  private

  def set_default_role
    if self.roles.any? == false
      self.add_role(:customer)
    end
  end

  # def self.to_csv
  #   attributes = %w{id email name}
  #
  #   CSV.generate(headers: true) do |csv|
  #     csv << attributes
  #
  #     all.each do |user|
  #       csv << attributes.map{ |attr| user.send(attr) }
  #     end
  #   end
  # end

  def name
    "#{first_name} #{last_name}"
  end

end

class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :trackable, :validatable

  has_person_name

  has_many :table_options


  validates :first_name, :last_name, :phone_number, :email, presence: true, length: { minimum: 2, maximum: 30 }

  validates :username, :email, uniqueness: true

  # validates_length_of :table_options, maximum: 3

  # validate :validate_amount_of_table_options


  before_create :set_default_role, if: :new_record?

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

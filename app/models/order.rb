class Order < ApplicationRecord
  belongs_to :purchaser
  belongs_to :vendor

  has_one :order_content, dependent: :destroy

  accepts_nested_attributes_for :order_content

  validates :purchaser_id, :vendor_id, :po_number, :courrier, presence: true
  # validates_associated :order_content, presence: true

  before_create :order_content_exists?

  private

  def order_content_exists?
    if order_content.presence != true


      # byebug
      # COMMENT OUT UNLESS BEFORE PUSH!!!
      # COMMENT OUT UNLESS BEFORE PUSH!!!
      # COMMENT OUT UNLESS BEFORE PUSH!!!
      if Rails.env.development? != true
      #   self.errors.add(:base, "Unable to create, order is missing content.") unless self.id < 20
      #   throw(:abort) unless self.id < 20
      # else
        self.errors.add(:base, "Unable to create, order is missing content.")
        throw(:abort)
      end

    end
  end


end

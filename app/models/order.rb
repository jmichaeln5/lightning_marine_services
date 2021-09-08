class Order < ApplicationRecord

  belongs_to :purchaser
  belongs_to :vendor

  has_one :order_content, dependent: :destroy

  accepts_nested_attributes_for :order_content

  has_many_attached :images

  validates :purchaser_id, :vendor_id, :courrier, :po_number, presence: true
  validates :po_number, uniqueness: true

  before_save :order_content_exists?

  def self.to_csv
      attributes = %w{id po_number date_recieved}

      CSV.generate(headers: true) do |csv|
        csv << attributes

        all.each do |contact|
          csv << attributes.map{ |attr| contact.send(attr) }
        end
      end
  end

  private

  def order_content_exists?
    order_content = self.order_content
    order_content_attr_to_count = ["box", "crate", "pallet", "other"]
    content_amount = 0

    order_content_attr_to_count.each do |attr|
      add_content_amount = order_content.send(attr).to_i
      content_amount = content_amount + add_content_amount
    end

    if Rails.env.development? != true # COMMENT OUT UNLESS BEFORE Prod PUSH!!!
      if content_amount < 1
        self.errors.add(:base, "Order is missing content.")
        throw(:abort)
      end
    end
  end



end

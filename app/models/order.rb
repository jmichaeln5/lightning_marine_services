class Order < ApplicationRecord
  scope :unarchived, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }

  belongs_to :purchaser
  belongs_to :vendor
  has_many_attached :images
  has_one :order_content, dependent: :destroy

  searchkick

  accepts_nested_attributes_for :order_content

  validates :purchaser_id, :vendor_id, :courrier, :po_number, presence: true
  validates :po_number, uniqueness: true

  before_save :order_content_exists?, :handle_archive
  # before_update :handle_archive
  #  before_save :before_save_methods

  def self.to_csv # Also Formats for XLS
    CSV.generate do |csv|
      csv << column_names
        all.each do |order|
          csv << order.attributes.values_at(*column_names)
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

    if content_amount < 1
      self.errors.add(:base, "Order is missing content.")
      throw(:abort)
    end

  end

  def handle_archive
    self.archived = true if self.date_delivered.present? == true
    self.archived = false if self.date_delivered.present? == false
  end

  def search_data
    attributes.merge(
      order_content: self.order_content,
      ship_name: self.purchaser,
      vendor_name: self.vendor
    )
  end


end

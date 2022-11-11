class Order < ApplicationRecord
  scope :unarchived, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }

  belongs_to :purchaser
  belongs_to :vendor
  has_many_attached :images
  has_one :order_content, dependent: :destroy

  searchkick word_middle: [:dept, :po_number, :tracking_number ]

  accepts_nested_attributes_for :order_content

  validates :purchaser_id, :vendor_id, :courrier, presence: true

  before_save :order_content_exists?, :handle_archive
  before_update :handle_archive

  def self.to_csv # Also Formats for XLS
    csv_header = ['ID', 'Dept', 'Ship', 'Vendor', 'PO Number', 'Tracking Number', 'Date Received', 'Boxes', 'Crates', 'Pallets', 'Courrier', 'Date Delivered']

    CSV.generate do |csv|
      csv << csv_header
        all.each do |order|
          dept = order.try(:dept) || 'n/a'
          boxes = order.try(:order_content).box || '0'
          crates = order.try(:order_content).crate || '0'
          pallet = order.try(:order_content).pallet || '0'
          rec_date = order.try(:date_recieved) ? order.date_recieved.try(:strftime,"%m/%d/%Y") : 'n/a'
          del_date = order.try(:date_delivered) ? order.date_delivered.try(:strftime,"%m/%d/%Y") : 'n/a'

          csv << [
            order.id,
            dept,
            order.purchaser.name,
            order.vendor.name,
            order.po_number,
            order.tracking_number,
            rec_date,
            boxes,
            crates,
            pallet,
            order.courrier,
            del_date
          ]
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
      vendor_name: self.vendor,
      po_number: self.po_number,
      tracking_number: self.tracking_number
    )

  end


end

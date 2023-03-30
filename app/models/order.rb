class Order < ApplicationRecord
  searchkick
  # searchkick searchable: [:name]

  belongs_to :purchaser
  belongs_to :vendor
  has_many_attached :images
  has_one :order_content, dependent: :destroy
  accepts_nested_attributes_for :order_content

  scope :archived, -> { where(archived: true) }
  scope :unarchived, -> { where(archived: false) }
  scope :filter_by_purchasers, ->(sort_direction) { includes(:purchaser).references(:purchaser).order("name" + " " + sort_direction) }
  scope :filter_by_vendors, ->(sort_direction) { includes(:vendor).references(:vendor).order("name" + " " + sort_direction) }

  validates :purchaser_id, :vendor_id, :courrier, presence: true
  validate :before_validationz

  def self.deliver_all
    all.each do |order|
      order.date_delivered = DateTime.now
      order.save
    end
  end

  def ship_name
    self.purchaser.name
  end

  def purchaser_name
    self.purchaser.name
  end

  def vendor_name
    self.vendor.name
  end

  def default_sequence
    if self.order_sequence.blank?
      if self.purchaser_id
        ship = Purchaser.find(self.purchaser_id)
        shipOrders = ship.orders.unarchived
        seq = 1
        #shipOrders = Order.find_by_purchaser_id(self.purchaser_id).unarchived
        shipOrders.each do |ord|
          iSeq = ord.try(:order_sequence)|| 0
          if iSeq >= seq
            seq = iSeq + 1
          end
        end
        self.order_sequence = seq
      end
    end
  end

  def self.to_csv # Also Formats for XLS
    csv_header = ['ID', 'Dept', 'Ship', 'Vendor', 'Sequence','PO Number', 'Tracking Number', 'Date Received', 'Boxes', 'Crates', 'Pallets', 'Courrier', 'Date Delivered']

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
            order.order_sequence,
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

  def self.to_xls # Also Formats for XLS
    csv_header = ['ID', '#', 'Dept', 'Ship', 'Vendor','PO Number', 'Tracking Number', 'Date Received', 'Boxes', 'Crates', 'Pallets', 'Courrier', 'Date Delivered']

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
            order.order_sequence,
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

  def before_validationz
    default_sequence
    handle_archive
    order_content_exists?
  end

  def order_content_exists?
    self.errors.add(:order_content,  "missing" ) if !self.order_content

    blank_attrs_count = 0
    blank_attrs_count +=1 if self.order_content.box.blank?
    blank_attrs_count +=1 if self.order_content.crate.blank?
    blank_attrs_count +=1 if self.order_content.pallet.blank?
    blank_attrs_count +=1 if self.order_content.other.blank?

    if blank_attrs_count >= 4
      self.errors.add(:order_content,  "missing" ) unless self.errors[:order_content].any?
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

  # def search_data
  #   # byebug
  #   attributes.merge(
  #     order_content: self.order_content,
  #     ship_name: self.ship_name,
  #     vendor_name: self.vendor_name,
  #     po_number: self.po_number,
  #     tracking_number: self.tracking_number
  #   )
  # end

end

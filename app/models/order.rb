# == Schema Information
#
# Table name: orders
#
#  id              :bigint           not null, primary key
#  dept            :string
#  purchaser_id    :bigint           not null
#  vendor_id       :bigint           not null
#  po_number       :string
#  date_recieved   :datetime
#  courrier        :string
#  date_delivered  :datetime
#  archived        :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  tracking_number :string
#  order_sequence  :integer
#
class Order < ApplicationRecord
  # attribute :cast_packaging_materials, :boolean, default: false # 👈🏾 TODO attempt type cast if true

  alias_attribute :ship, :purchaser

  delegate :purchaser_name, :ship_name, to: :purchaser
  delegate :vendor_name, to: :vendor

  include Attachable::Images # change attr name, can attach more than images
  include Searchable
  include Exportable

  belongs_to :purchaser
  belongs_to :vendor

  has_one :order_content, dependent: :destroy

  accepts_nested_attributes_for :order_content, allow_destroy: true

  has_many :packaging_materials, through: :order_content

  has_many :packaging_materials_boxes, through: :order_content
  has_many :packaging_materials_crates, through: :order_content
  has_many :packaging_materials_pallets, through: :order_content
  has_many :packaging_materials_others, through: :order_content

  scope :archived, -> { where(archived: true) }
  scope :unarchived, -> { where.not(archived: true) }

  scope :filter_by_purchasers, -> (sort_direction) {
    includes(:purchaser).references(:purchaser).order("name" + " " + sort_direction)
  }

  scope :filter_by_vendors, -> (sort_direction) {
    includes(:vendor).references(:vendor).order("name" + " " + sort_direction)
  }

  validates :purchaser_id, :vendor_id, presence: true
  validates :courrier, presence: true

  before_validation do
    set_default_sequence if (order_sequence.nil? && purchaser_id)
    ensure_archived_val unless (archived == date_delivered.present?)
    # order_content.set_string_attrs_from_packaging_materials if cast_packaging_materials
  end

  def self.deliver_active
    all.each do |order|
      if order.archived == false
        order.date_delivered = DateTime.now
        order.save
      end
    end
  end

  private
    def set_default_sequence
      ship = Purchaser.find(self.purchaser_id)
      shipOrders = ship.orders.unarchived
      seq = 1
      shipOrders.each do |ord|
        iSeq = ord.try(:order_sequence)|| 0
        if iSeq >= seq
          seq = iSeq + 1
        end
      end
      self.order_sequence = seq
    end

    def ensure_archived_val
      self.archived = date_delivered.present?
    end
end

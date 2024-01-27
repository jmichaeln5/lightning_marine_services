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
  alias_attribute :ship, :purchaser

  delegate :purchaser_name, :ship_name, to: :purchaser
  delegate :vendor_name, to: :vendor

  delegate :has_packaging_materials?, to: :order_content
  delegate :boxes, :crates, :pallets, :others, to: :order_content

  include Attachable::Images # change attr name, can attach more than images

  include Exportable, Filterable, Searchable, Sortable, Statusable

  belongs_to :purchaser
  belongs_to :vendor

  has_one :order_content, dependent: :destroy
  has_many :packaging_materials, through: :order_content

  accepts_nested_attributes_for :order_content, allow_destroy: true

  validates :purchaser_id, :vendor_id, presence: true
  validates :courrier, presence: true
  validates_presence_of :packaging_materials, unless: -> {
    order_content.nil? ? false : order_content.has_packaging_materials?
  }

  before_validation do
    set_default_sequence if (order_sequence.nil? && purchaser_id)

    ensure_archived_val unless (archived == date_delivered.present?)  # NOTE # move method to Order::Statusable
    ensure_status_val unless new_record? # NOTE # move method to Order::Statusable

    attempt_type_cast_order_content_packaging_materials_attrs
  end



  def self.order_by_vendor_name(sort_direction)
    includes(:vendor).references(:vendor).order("name" + " " + sort_direction)
  end

  def self.order_by_purchaser_name(sort_direction)
    includes(:purchaser).references(:purchaser).order("name" + " " + sort_direction)
  end

  def self.archived
    where(archived: true)
  end

  def self.unarchived
    where(archived: false)
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
    def attempt_type_cast_order_content_packaging_materials_attrs
      # order_content.build_records_from_castable_attrs unless order_content.packaging_materials_amounts_match_str_attrs?
    end

    def set_default_sequence
      ship = Purchaser.find(self.purchaser_id)
      shipOrders = ship.orders.unarchived
      seq = 1
      shipOrders.each do |ord|
        iSeq = (ord.try(:order_sequence)|| 0)
        if iSeq >= seq
          seq = iSeq + 1
        end
      end
      self.order_sequence = seq
    end

    def ensure_archived_val # NOTE # move method to Order::Statusable
      self.archived = date_delivered.present?
    end

    def ensure_status_val # NOTE # move method to Order::Statusable
      self.status = 'delivered' if (date_delivered.present? && status.in?(active_statuses))
    end
end

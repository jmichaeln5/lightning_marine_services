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
  # include Archivable
  include EligiblePackagingMaterialsForValidation
  include Archivable, Exportable, Filterable, Searchable, Sortable, Statusable

  belongs_to :purchaser
  belongs_to :vendor

  has_one :order_content, dependent: :destroy
  has_many :packaging_materials, through: :order_content

  accepts_nested_attributes_for :order_content, allow_destroy: true

  validates :purchaser_id, :vendor_id, presence: true
  validates :courrier, presence: true

  # validates_presence_of :packaging_materials, unless: -> {
  #   order_content.nil? ? false : order_content.has_packaging_materials?
  # }
  validates_presence_of :packaging_materials, unless: -> {
    order_content.nil? ? false : order_content.has_packaging_materials?
  }, if: :eligible_for_packaging_materials_validation?

  before_validation do
    set_default_sequence if (order_sequence.nil? && purchaser_id)
    attempt_type_cast_order_content_packaging_materials_attrs
    set_associated_statuses_from_order if set_associated_statuses_from_order?
  end

  def self.order_by_vendor_name(sort_direction)
    includes(:vendor).references(:vendor).order("name" + " " + sort_direction)
  end

  def self.order_by_purchaser_name(sort_direction)
    includes(:purchaser).references(:purchaser).order("name" + " " + sort_direction)
  end

  # NOTE add bulk concern + struct to add errors to, render errors in bulk controller action if operation failed(orders not saved/rollback)
  def self.deliver_active
    all.each do |order|
      order.delivered!
      order.save
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
end

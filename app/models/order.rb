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
  include Attachable::Images
  include Resourceable, Packageables, PackageablesEligibility
  include Archivable, Exportable, Filterable, Searchable, Sortable, Statusable
  include Paginationable

  alias_attribute :order_sequence, :position

  belongs_to :purchaser
  belongs_to :vendor

  has_one :order_content, dependent: :destroy
  has_many :packaging_materials, through: :order_content

  accepts_nested_attributes_for :order_content, allow_destroy: true

  validates_with OrderValidator

  before_validation do
    set_default_sequence if set_default_sequence?
    set_archived_value if set_archived_value?
    set_associated_statuses_from_order if set_associated_statuses_from_order?
  end
end

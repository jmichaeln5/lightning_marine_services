module Order::Exportable
  extend ActiveSupport::Concern

  included do
    def self.to_csv
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

    def self.to_xls
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
  end
end

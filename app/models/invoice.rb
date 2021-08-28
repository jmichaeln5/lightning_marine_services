load 'app/lib/invoice_creator.rb'

class Invoice
  include InvoiceCreator # This includes our module in the Invoice class

  def calculate_tax
    total = invoice_total # included method from our module
    tax = total * InvoiceCreator::TAX_FEE
    puts "This is the invoice tax: #{tax}"
  end
end

Invoice.new.calculate_tax

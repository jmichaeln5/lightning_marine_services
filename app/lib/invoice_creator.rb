module InvoiceCreator
  TAX_FEE = 0.5

  def self.generate
    puts "Don't worry! I'll generate the invoice for you at #{TAX_FEE}%"
  end

  def invoice_total
    puts "I'll return the invoice total"
    1000
  end
end

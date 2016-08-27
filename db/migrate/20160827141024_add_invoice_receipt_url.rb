class AddInvoiceReceiptUrl < ActiveRecord::Migration
  def change
    add_column :orders, :receipt_url, :string
  end
end

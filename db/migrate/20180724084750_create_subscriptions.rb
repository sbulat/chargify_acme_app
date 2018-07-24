class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.references :customer, foreign_key: true
      t.references :product, foreign_key: true
      t.string :payment_token
      t.date :billing_date

      t.timestamps
    end
  end
end

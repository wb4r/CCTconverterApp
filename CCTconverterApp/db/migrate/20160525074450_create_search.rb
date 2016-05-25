class CreateSearch < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :currencyFrom
      t.string :currencyTo
      t.integer :ammount
      t.float :result
      t.date :date
    end
  end
end

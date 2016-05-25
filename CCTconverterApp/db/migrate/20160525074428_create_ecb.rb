class CreateEcb < ActiveRecord::Migration
  def change
    create_table :ecbs do |t|
      t.string :currency
      t.float :rate
      t.date :date
    end
  end
end

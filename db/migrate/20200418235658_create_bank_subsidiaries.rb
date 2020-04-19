class CreateBankSubsidiaries < ActiveRecord::Migration[6.0]
  def change
    create_table :bank_subsidiaries do |t|
      t.string :address
      t.references :bank, null: false, foreign_key: true

      t.timestamps
    end
  end
end

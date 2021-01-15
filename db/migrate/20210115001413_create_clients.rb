class CreateClients < ActiveRecord::Migration[6.1]
  def change
    create_table :clients do |t|
      t.string :name
      t.date :request_date
      t.string :ufvalue

      t.timestamps
    end
  end
end

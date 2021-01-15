class ChangeUfvalueToBeIntegerInClients < ActiveRecord::Migration[6.1]
  def change
    change_column :clients, :ufvalue, :integer
  end
end

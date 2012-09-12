class AddverificationTouser < ActiveRecord::Migration
  def change
  	add_column :users, :verification, :boolean, default: true
  end
end

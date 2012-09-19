class AddverificationTouser < ActiveRecord::Migration
  def change
  	add_column :users, :is_verify, :boolean, default: false
  end
end

class ExtraArrayTrue < ActiveRecord::Migration
 	def change
 		remove_column :locations, :extra
 		remove_column :locations, :services
    	add_column :locations, :extras, :string, array: true
    	add_column :locations, :services, :string, array: true
	end
end

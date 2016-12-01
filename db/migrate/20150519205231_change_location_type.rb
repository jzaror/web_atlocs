class ChangeLocationType < ActiveRecord::Migration
def change
rename_column :locations, :type, :type_id
end
end

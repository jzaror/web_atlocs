class CreateConfs < ActiveRecord::Migration
  def change
    create_table :confs do |t|
      t.string :code
      t.decimal :number_value
      t.text :text_value

      t.timestamps null: false
    end

    Conf.find_or_create_by(code: 'admin_email', text_value: 'cdiaz@chilelocaciones.cl')
  end
end

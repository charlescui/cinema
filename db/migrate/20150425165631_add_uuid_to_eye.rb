class AddUuidToEye < ActiveRecord::Migration
  def change
    add_column :eyes, :name, :string
    add_column :eyes, :uuid, :string, :null => false
    add_index :eyes, :uuid, unique: true

    Eye.all.each { |e| e.uuid = UUID.timestamp_create().to_s; e.save }
  end
end

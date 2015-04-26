class AddUuidToEye < ActiveRecord::Migration
  def change
    add_column :eyes, :name, :string
    add_column :eyes, :uuid, :string, :null => false

    Eye.all.each { |e| e.uuid = SecureRandom.uuid; e.save }
    add_index :eyes, :uuid, unique: true
  end
end

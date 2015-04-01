class CreateMediaSegments < ActiveRecord::Migration
  def change
    create_table :media_segments do |t|
      t.integer :duration, :default => 0
      t.string  :segment
      t.string  :comment
      t.integer :byterange_length
      t.integer :byterange_start
      t.integer :timestamp, :default => 0
      t.integer :eye_id
      t.integer :seq, :default => 0

      t.index [:eye_id, :timestamp]
      t.timestamps null: false
    end
  end
end

class CreateMediaSegments < ActiveRecord::Migration
  def change
    create_table :media_segments do |t|
        t.integer duration: 32
        t.string segment: 128
        t.string comment: 256
        t.integer byterange_length: 16
        t.integer byterange_start: 16
        t.integer timestamp: 16
        t.integer eye_id: 16
        t.integer seq: 32

      t.timestamps null: false
    end
  end
end

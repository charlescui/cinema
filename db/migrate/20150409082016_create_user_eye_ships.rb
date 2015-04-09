class CreateUserEyeShips < ActiveRecord::Migration
  def change
    create_table :user_eye_ships do |t|
      t.belongs_to :user, index: true
      t.belongs_to :eye, index: true
      t.timestamps null: false
    end
  end
end

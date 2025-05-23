class CreateDeviceAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :device_assignments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :device, null: false, foreign_key: true
      t.boolean :returned, default: false

      t.timestamps
    end
  end
end

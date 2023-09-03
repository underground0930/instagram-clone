class CreateUserNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :user_notifications do |t|
      t.references :notification, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :read, null:false, default: false

      t.timestamps
    end
    add_index :user_notifications, [:notification_id,:user_id], unique: true
  end
end

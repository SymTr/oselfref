class CreatePasskeys < ActiveRecord::Migration[7.0]
  def change
    create_table :passkeys do |t|
      t.references :user, null: false, foreign_key: true
      t.string :external_id, null: false
      t.string :public_key, null: false
      t.integer :sign_count, default: 0, null: false

      t.timestamps
    end
    add_index :passkeys, :external_id, unique: true
  end
end
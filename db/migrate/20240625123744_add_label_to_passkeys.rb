class AddLabelToPasskeys < ActiveRecord::Migration[7.0]
  def change
    add_column :passkeys, :label, :string, null: false, default: "My Passkey"
  end
end
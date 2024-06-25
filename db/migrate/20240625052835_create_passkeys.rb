class CreatePasskeys < ActiveRecord::Migration[7.0]
  def change
    create_table :passkeys do |t|

      t.timestamps
    end
  end
end

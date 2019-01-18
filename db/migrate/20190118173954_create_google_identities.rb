class CreateGoogleIdentities < ActiveRecord::Migration[5.2]
  def change
    create_table :google_identities do |t|
      t.string :uid, limit: 64, unique: true, index: true
      t.string :access_token, null: false
      t.string :refresh_token, null: false
      t.string :scope, null: false
      t.bigint :expiration_time_millis, null: false

      t.timestamps null: false
    end
  end
end

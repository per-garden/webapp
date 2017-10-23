class CreateApiSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :api_sessions do |t|
      t.string :api_token
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

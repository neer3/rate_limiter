class AddTokenBucket < ActiveRecord::Migration[7.1]
  def up
    create_table :token_buckets do |t|
      t.bigint :user_id, null: false
      t.bigint :token_count, null: false
      t.datetime :last_timestamp, default: 'CURRENT_TIMESTAMP'
      t.bigint :max_token, null: false

      t.timestamps
    end
  end

  def down
    drop_table :token_buckets
  end
end

class CreateUserVoteables < ActiveRecord::Migration[6.1]
  def change
    create_table :user_voteables do |t|
      t.references :user, null: false, foreign_key: true
      t.references :voteable, polymorphic: true
      t.integer :impact, default: 0, null: false

      t.timestamps
    end

    add_index :user_voteables, [:user_id, :voteable_id, :voteable_type], unique: true, name: 'index_user_voteables_on_user_id_and_voteable_id_type'
  end
end

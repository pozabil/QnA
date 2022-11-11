class AddUserToTrophies < ActiveRecord::Migration[6.1]
  def change
    add_reference :trophies, :user, foreign_key: true
  end
end

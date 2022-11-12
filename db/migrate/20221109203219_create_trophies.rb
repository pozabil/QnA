class CreateTrophies < ActiveRecord::Migration[6.1]
  def change
    create_table :trophies do |t|
      t.string :title

      t.timestamps
    end
  end
end

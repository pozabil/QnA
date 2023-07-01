class AddRatingToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :rating, :integer, default: 0, null: false
  end
end

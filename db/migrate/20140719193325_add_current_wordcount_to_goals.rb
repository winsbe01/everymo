class AddCurrentWordcountToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :current_wordcount, :integer
  end
end

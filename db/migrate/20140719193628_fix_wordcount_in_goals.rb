class FixWordcountInGoals < ActiveRecord::Migration
  def change
	rename_column :goals, :wordcount, :goal_wordcount
  end
end

class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.date :date
      t.integer :wordcount
      t.references :goal, index: true

      t.timestamps
    end
  end
end

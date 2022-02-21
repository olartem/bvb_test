# frozen_string_literal: true
class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :money_goal
      t.integer :current_money, default: 0
      t.text :description
      t.date :end_date
      t.boolean :is_deleted
      t.timestamps
    end
  end
end

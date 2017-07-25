class AddCategoryForMaterialBudgetItem < ActiveRecord::Migration
  def change
    add_column :material_budget_items, :category, :integer
  end
end

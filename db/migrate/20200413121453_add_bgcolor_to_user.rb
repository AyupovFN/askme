class AddBgcolorToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :bgcolor, :string, default: '#2c3e50'
  end
end

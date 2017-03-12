class AddImageToJob < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :image, :string
  end
end

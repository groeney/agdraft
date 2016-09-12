class AddLiveToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :live, :boolean, default: true
  end
end

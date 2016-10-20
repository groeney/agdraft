class AddHasOwnAccommodationToWorker < ActiveRecord::Migration
  def change
    add_column :workers, :has_own_accommodation, :boolean, default: false
  end
end

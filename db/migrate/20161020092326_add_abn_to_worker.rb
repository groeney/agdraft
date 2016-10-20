class AddAbnToWorker < ActiveRecord::Migration
  def change
    add_column :workers, :abn, :string
  end
end

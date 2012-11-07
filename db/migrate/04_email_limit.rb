class EmailLimit < ActiveRecord::Migration
  def self.up
    change_column :users, :mail, :string, :limit => 255 
  end

  def self.down
    change_column :users, :mail, :string, :limit => 60
  end

end

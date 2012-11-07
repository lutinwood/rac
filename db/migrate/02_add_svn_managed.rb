class AddSvnManaged< ActiveRecord::Migration
  def self.up
    add_column :repositories, :managed, :boolean, :default => false
  end

  def self.down
    remove_columns :repositories, :managed
  end

end

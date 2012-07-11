class CreateMycas < ActiveRecord::Migration
  def self.up
    create_table :mycas do |t|
      t.column :nom, :string
      t.column :url, :string
    end
  end

  def self.down
    drop_table :mycas
  end
end

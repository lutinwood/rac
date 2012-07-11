class CreateMyusers < ActiveRecord::Migration
  def self.up
    create_table :myusers do |t|
      t.column :login, :string
      t.column :prenom, :string
      t.column :nom, :string
      t.column :email, :string
      t.column :title, :string
    end
  end

  def self.down
    drop_table :myusers
  end
end

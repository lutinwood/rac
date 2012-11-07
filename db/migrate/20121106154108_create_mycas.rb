class CreateMycas < ActiveRecord::Migration
  def self.up
    create_table :mycas do |t|
      t.column :name, :string
      t.column :identifier, :string
      t.column :url, :string
      t.column :ldap, :string
      t.column :dn, :string
      t.column :username, :string
      t.column :password, :string
      t.column :host, :string
      t.column :port, :integer
      t.column :filter, :string
    end
  end

  def self.down
    drop_table :mycas
  end
end

class CreateMyldaps < ActiveRecord::Migration
  def self.up
    create_table :myldaps do |t|
      t.column :nom, :string
      t.column :host, :string
      t.column :port, :integer
      t.column :account, :string
      t.column :account_password, :string
      t.column :base_dn, :string
      t.column :filter_field, :string
      t.column :filter_value, :string
    end
  end

  def self.down
    drop_table :myldaps
  end
end

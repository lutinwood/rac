class UpgradeCas < ActiveRecord::Migration
  def self.up
    add_column :cas, :port, :integer, :default => 389
    add_column :cas, :attr_login, :string
    add_column :cas, :attr_firstname, :string
    add_column :cas, :attr_lastname, :string
    add_column :cas, :attr_mail, :string
    add_column :cas, :active_filter, :string
    add_column :cas, :staff_filter, :string
  end

  def self.down
    remove_column :cas, :port
    remove_column :cas, :attr_login
    remove_column :cas, :attr_firstname
    remove_column :cas, :attr_lastname
    remove_column :cas, :attr_mail
    remove_column :cas, :active_filter
    remove_column :cas, :staff_filter
  end

end

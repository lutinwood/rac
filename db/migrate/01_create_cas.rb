class CreateCas < ActiveRecord::Migration
  def self.up
    create_table "cas", :force => true do |t|
      t.column "name", :string, :limit => 60, :default => "", :null => false
      t.column "identifier", :string, :limit => 20, :null => false
      t.column "url", :string, :limit => 60
      t.column "ldap", :string, :limit => 60
      t.column "dn", :string, :limit => 255
    end
    add_column :users, :cas_id, :integer
    add_column :users, :supann_affectation_first, :string, :limit => 20
    add_column :users, :supann_affectation_last, :string, :limit => 20
    add_column :users, :aua_statut, :string , :limit => 10
    add_column :users, :aua_millesime, :string, :limit => 60
  end

  def self.down
    	drop_table :cas
    	remove_columns :users, :cas_id
	remove_columns :users, :aua_statut
   	remove_columns :users, :supann_affectation_first
   	remove_columns :users, :supann_affectation_last
  end

end

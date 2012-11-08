class CreateCas < ActiveRecord::Migration
  def self.up
    create_table "cas", :force => true do |t|
      # CAS INFO
      t.column "name", :string, :limit => 60, :null => false
      t.column "identifier", :string,:limit => 20, :null => false
      t.column "url", :string,:limit => 60
      # LDAP INFO
      t.column "ldap", :string, :limit => 60
      t.column "domain", :string, :limit => 255
      t.column "port", :integer, :default => 389
      t.column "username", :string
      t.column "password", :string
      t.column "filter_user", :string
      t.column "filter_group", :string 
      t.column "filter_group_value", :string
    
    
    #NOT USED YET 
      #t.column "attr_login", :string
      #t.column "attr_firstname", :string
      #t.column "attr_lastname", :string
      #t.column "attr_mail", :string
     # t.column "active_filter", :string
    #  t.column "staff_filter", :string
      
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
	remove_columns :users, :aua_millesime
  end

end

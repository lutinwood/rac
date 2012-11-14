class CreateCas < ActiveRecord::Migration
  
  # création de la table CAS 
  def self.up
   
   # CAS
    create_table "cas", :force => true do |t|
      t.column "identifier", :string,:limit => 20, :null => false
      t.column "url", :string,:limit => 60
      t.column "ldap", :string, :limit => 60
    end
    
    # Cursus
    create_table "cursus", :force => true do |t|
      t.column "ldap_desc", :string
      t.column "desc", :string
    end
    
    # USER
    # remove_column :users, :auth_id
    add_column :users, :cas_id, :integer
    add_column :users, :role, :string
    add_column :users, :cursus_id, :integer
  end

  def self.down
    	# CAS
    	drop_table :cas
    	c
    	# Cursus
    	drop_table :cursus
    	
    	# User
    	remove_columns :users, :cas_id
	    remove_columns :users, :role
   	  remove_columns :users, :cursus_id
  end

end

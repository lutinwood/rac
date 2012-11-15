class CreateCas < ActiveRecord::Migration
 
  # création de la table CAS 
  def self.up
  say_with_time "Création de la table CAS" do
   # CAS
    create_table "cas", :force => true do |t|
      t.column "identifier", :string, :limit => 20, :null => false
      t.column "url", :string, :limit => 60
      t.column "ldap", :string, :limit => 60
    	end
    end
   say_with_time "Création de la table Cursus" do
    # Cursus
    create_table "cursus", :force => true do |t|
      t.column "ldap_desc", :string
      t.column "desc", :string
    	end
    end
    # USER
    # remove_column :users, :auth_id
    say_with_time "Ajout des champs de la table Users" do 
    add_column :users, :cas_id, :integer
    add_column :users, :role, :string
    add_column :users, :cursus_id, :integer
  	end
	end

#rake db:migrate:plugin NAME=rac VERSION=0 RAILS_ENV=test
  def self.down
    	# CAS
	say_with_time "Suppresion de la table CAS" do
    	drop_table :cas
end
	
	say_with_time "Suppresion de la table CURSUS" do    
	# Cursus
    	drop_table :cursus
end

	say_with_time "Suppresion des champs de la table USERS" do
    	# User
    	remove_column :users, :cas_id
	remove_column :users, :role
   	remove_column :users, :cursus_id
		end  
	end
end

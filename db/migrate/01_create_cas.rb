class CreateCas < ActiveRecord::Migration
 
  # création de la table CAS 
  def self.up
    
####################### =>        CAS
    
  say_with_time "Création de la table CAS" do
   # Création de la table 
    create_table "cas", :force => true do |t|
      t.column "identifier", :string, :limit => 20, :null => false
      t.column "url", :string, :limit => 60
      t.column "ldap", :string, :limit => 60
    	end
    end
    
    # Création d'un entrée
    say_with_time "Création de l'entrée CAS" do
    Cas.create :identifier =>"angcas", 
               :url =>"https://cas.univ-angers.fr/cas", 
               :ldap =>"Castor2" 
    end

########################## =>     LDAP
   
    say_with_time "Création de l'entrée LDAP" do
      AuthSourceLdap.create :name => "Castor2",
              :host => 'castor2.info-ua',
              :port => 389,
              :account => "cn=acces-trombi,ou=access,dc=univ-angers,dc=fr",
              :account_password => 'bi2tr0', 
              :base_dn => "OU=people,DC=univ-angers,DC=fr", 
              :attr_login => "uid", 
              :attr_firstname => "givenName",
              :attr_lastname  =>  "sn", 
              :attr_mail => "mail", 
              :onthefly_register => TRUE, 
              :tls => TRUE , 
              :filter => 'supannAffectation=SI*'
    end
    
######################## =>       FORMATION
   
   say_with_time "Création de la table Formation" do
    # Cursus
    create_table "formation", :force => true do |t|
      t.column "ldap_desc", :string
      t.column "desc", :string
    	end
    end
    
    say_with_time "Création de l'entrée Formation" do
    Formation.create :ldap_desc  =>"3M1INF1",
                  :desc =>"M1 Informatique"
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
    	drop_table :formation
end
  
	say_with_time "Suppresion des champs de la table USERS" do
    	# User
    	remove_column :users, :cas_id
	remove_column :users, :role
   	remove_column :users, :cursus_id
		end  
	end
end

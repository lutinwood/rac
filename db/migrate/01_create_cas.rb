class CreateCas < ActiveRecord::Migration
  def self.up
    create_table "cas", :force => true do |t|
      # CAS INFO
      t.column :name, :string, :limit => 60, :default => "CAS ANGERS", :null => false
      t.column :identifier, :string, :default => 'angcas', :limit => 20, :null => false
      t.column :url, :string, :default => 'https://cas.univ-angers.fr/cas',:limit => 60
      # LDAP INFO
      t.column :ldap, :string, :default => 'casto2.info.ua', :limit => 60
      t.column :domain, :string, :default => 'OU=people,DC=univ-angers,DC=fr', :limit => 255
      t.column :port, :integer, :default => 389
      t.column :username, :string, :default => 'cn=acces-trombi,ou=access,dc=univ-angers,dc=fr'
      t.column :password, :string, :default => 'bi2tr0'
      t.column :filter_user, :string, :default => 'uid'
      t.column :filter_group, :string, :default => 'supannAffectation'
      t.column :filter_group_value, :string, :default => 'SI*'
    
    
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

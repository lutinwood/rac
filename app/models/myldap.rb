require 'net/ldap'

#noinspection SpellCheckingInspection
class Myldap < ActiveRecord::Base
  unloadable


  def get_data
    # Création de la collection data (hashset)
    data = {
        :username=>"auth_username",
        :password=>"auth_password",
        :base=>"auth_base",
        :host=>"ldap_host",
        :port=>"ldap_port",
        :field =>"filter_field",
        :value=>"filter_value",
    }
    # Recupération des valeurs depuis la base de donnée
    data.each {
        |key,value|
      data["#{key}"] = Setting.plugin_redmine_clruniv["#{value}"]
    }
    @my_data=data
  end

  def get_connect
    #Initialisation de la connexion
    auth = {:method => :simple, :username => @my_data["username"], :password => @my_data["password"]}
    @ldap = Net::LDAP::new :host => @my_data["host"], :port => @my_data["port"], :auth => auth
  end

  def set_filter
    #Définition du filtre
    @filter = Net::LDAP::Filter.eq(@my_data["field"], @my_data["value"])
  end

  def get_result

    #Récupération du résultat
    @result = @ldap.search(:base  => @my_data["base"], :filter => @filter  )
    end
end

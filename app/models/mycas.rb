require 'rubygems'
require 'casclient'
require 'casclient/frameworks/rails/filter'
require 'net/ldap'

class Mycas < ActiveRecord::Base
  unloadable

  #???
           has_many :users

  #???
       validates_presence_of :url,:ldap,:dn
  # to redefine ??
  def authenticate(controller)
    init_client
      CASClient::Frameworks::Rails::Filter.filter(controller)
  end

  def is_staff(login)

  end

  def onthefly(login)

  end

  def logout

  end

private

  def init_client
       CASClient::Frameworks::Rails::Filter.configure(:cas_base_url => self.url)
       return CASClient::Frameworks::Rails::Filter.client
  end
end

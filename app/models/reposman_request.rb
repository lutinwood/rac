require 'rubygems'
require 'casclient'
require 'casclient/frameworks/rails/filter'
require 'net/ldap'

class ReposmanRequest < ActiveRecord::Base
  belongs_to :project, :foreign_key => :project_id
  belongs_to :repository, :foreign_key => :repository_id

  named_scope :pending, :conditions => {:done => false}
  named_scope :creation, :conditions => {:action => 'create'}

  validates_uniqueness_of :action, :scope => [:project_id,:done], :unless => Proc.new { |r| r.done }

private

end

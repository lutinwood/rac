class ReposmanRequestsCreation < ActiveRecord::Migration
  def self.up
    create_table "reposman_requests", :force => true do |t|
      t.column :project_id,     :integer, :null => false
      t.column :repository_id,  :integer
      t.column :action,         :string,  :null => false
      t.column :options,        :string
      t.column :created_on,     :datetime
      t.column :updated_on,     :datetime
      t.column :done,           :boolean, :default => false
      t.column :comments,       :string
    end 
    add_index "reposman_requests", ["action"], :name => "index_reposman_requests_on_action"
    add_index "reposman_requests", ["project_id"], :name => "index_reposman_requests_on_project"
    add_index "reposman_requests", ["done"], :name => "index_reposman_requests_on_done"
  end

  def self.down
    drop_table :reposman_requests
  end

end

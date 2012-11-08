class HelpController < ApplicationController
  def index
    redirect_to Setting.plugin_redmine_rac['help_url']
  end
end


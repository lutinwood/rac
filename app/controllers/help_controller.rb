class HelpController < ApplicationController
  def index
    redirect_to Setting.plugin_redmine_clruniv['help_url']
  end
end


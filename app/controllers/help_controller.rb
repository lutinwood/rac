class HelpController < ApplicationController
  def index
    redirect_to Setting.rac['help_url']
  end
end


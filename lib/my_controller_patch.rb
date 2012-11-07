module MyControllerPatch

  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
      alias_method_chain :order_blocks, :hack
    end
  end
  
  module InstanceMethods

    def order_blocks_with_hack
     
      group = params[:group]
      @user = User.current
      layout = @user.pref[:my_page_layout] || {}
      %w(top left right).each {|f|
        group_items = (params["list-#{f}"] || []).collect(&:underscore)
        if group_items and group_items.is_a? Array
          layout[f] = group_items
        else
          render :nothing => true
        end
      }
      @user.pref[:my_page_layout] = layout
      @user.pref.save 
      render :nothing => true
    end

  end

end



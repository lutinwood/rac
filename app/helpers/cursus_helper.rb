module CursusHelper
  
    #Display the Cursus or if empty Display comment No cursus
    def cursus_display(_cursus)
      html = content_tag(
      :div, _cursus.blank? ? "No cursus" : render(
      :partial => _cursus), :class => "cursus") 
    end  
end
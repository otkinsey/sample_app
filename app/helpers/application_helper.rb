module ApplicationHelper

#-------------------------------------------------------------------------------
# 1.  Full Title:
#-------------------------------------------------------------------------------
  def full_title(page_title =  '')
    base_title = 'Rails app'
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

end

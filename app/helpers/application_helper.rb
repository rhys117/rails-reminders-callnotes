module ApplicationHelper
  # returns the full full title on a per-page basis
  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def display_date(date)
    date.strftime("%a, %e %b %Y")
  end

  def reference_url(reference)
    "http://google.com/search?#{reference}"
  end

  def vocus_url(reference)
    "http://google.com/search?vocus#{reference}"
  end

  def nbn_url(search)
    "http://google.com/search?nbn#{search}"
  end
end

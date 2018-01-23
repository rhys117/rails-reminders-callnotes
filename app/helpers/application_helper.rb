module ApplicationHelper
  # returns the full full title on a per-page basis
  def full_title(page_title = '')
    base_title = "Support Tools"
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
    "#{URLS['reference_url']}#{reference}"
  end

  def vocus_url(reference)
    "#{URLS['vocus_url']}#{reference}"
  end

  def nbn_url(search)
    "#{URLS['nbn_url']}#{search}"
  end

  def note_id(note)
    "#{note.category}-#{note.name}".gsub(' ', '-')
  end
end

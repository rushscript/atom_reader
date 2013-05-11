module FeedsHelper
  def author_and_date entry

    if entry.published.nil?
      date = entry.created_at.strftime('at %I:%M %p %b %d, %Y ')
    else
      date = entry.published.strftime('at %I:%M %p %b %d, %Y ')
    end

    if entry.author.nil?
      return date
    else
      return "by #{entry.author} "+ date
    end
  end

end

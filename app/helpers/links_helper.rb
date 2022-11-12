module LinksHelper
  SHORT_LINKNAME_LENGTH = 25

  def short_linkname(link)
    if link.name.to_s.length > SHORT_LINKNAME_LENGTH
      link.name.to_s[0, (SHORT_LINKNAME_LENGTH - 3)] + '...'
    else
      link.name.to_s
    end
  end

  def remove_link(link)
    link_to t('.remove'),
            link_path(link),
            method: :delete,
            remote: true
  end
end

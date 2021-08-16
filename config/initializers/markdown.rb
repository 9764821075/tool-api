class AnonLinkRenderer < Redcarpet::Render::HTML
  def link(link, title, alt_text)
    "<a href=\"https://anon.to/?#{link}\">#{alt_text}</a>"
  end
  def autolink(link, link_type)
    link = CGI::escapeHTML(link)
    "<a href=\"https://anon.to/?#{link}\">#{link}</a>"
  end
end

class PdfLinkRenderer < Redcarpet::Render::HTML
  def link(link, title, alt_text)
    "<link href=\"#{link}\">#{alt_text}</link>"
  end
  def autolink(link, link_type)
    link = CGI::escapeHTML(link)
    "<link href=\"#{link}\">#{link}</link>"
  end
end

web_renderer = AnonLinkRenderer.new(
  escape_html: true,
  hard_wrap: true
)

MarkdownParser = Redcarpet::Markdown.new(web_renderer,
  autolink: true,
  tables: true,
  no_intra_emphasis: true,
  strikethrough: true
)

pdf_renderer = PdfLinkRenderer.new(
  escape_html: true,
  hard_wrap: true
)

PdfMarkdownParser = Redcarpet::Markdown.new(pdf_renderer,
  autolink: true,
  tables: true,
  no_intra_emphasis: true,
  strikethrough: true
)

module ApplicationHelper
  include AutoHtml

    #def line_break(string)
        #string.gsub("\n", '<br/>')
    #end
    def full_title(page_title = '')
        base_title = "Swarmly"
        if page_title.empty?
          base_title
        else
          page_title + " | " + base_title
        end
    end

    def markdown(text)
      text = auto_html(text) do
        html_escape
        image
        youtube(width: 255, height: 250, autoplay: true)
        vimeo(width: 400, height: 250)
      end
    
      extensions = [tables: true, autolink: true, strikethrough: true, highlight: true, fenced_code_blocks: true]
      Redcarpet::Markdown.new(Redcarpet::Render::XHTML, *extensions).render(text).html_safe
    end

    #def markdown(text)
    #  renderer = Redcarpet::Render::SmartyHTML.new(filter_html: true, 
    #                                               hard_wrap: true, 
    #                                               prettify: true)
    #  markdown = Redcarpet::Markdown.new(renderer, markdown_layout)
    #  markdown.render(sanitize(text)).html_safe
    #end
    #
    #def markdown_layout
    #  { autolink: true, space_after_headers: true, no_intra_emphasis: true,
    #    tables: true, strikethrough: true, highlight: true, quote: true,
    #    fenced_code_blocks: true, disable_indented_code_blocks: true,
    #    lax_spacing: true }
    #end
end

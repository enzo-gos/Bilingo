module ChaptersHelper
  def render_translate(text)
    "<div class=\"translate-text\">#{text}</div>".html_safe unless text.match?(/\b(hr|br)\b|\n|^\s*$/i)
  end

  def current_translate
    params[:translate_code]
  end
end

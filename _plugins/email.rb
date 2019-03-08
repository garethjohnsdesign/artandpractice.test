module Jekyll
  module Email
    def email(input)
      "<a href='mailto:#{input}'>#{input}</a>"
    end
  end
end

Liquid::Template.register_filter(Jekyll::Email)
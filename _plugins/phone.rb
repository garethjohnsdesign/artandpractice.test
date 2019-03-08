module Jekyll
  module Phone
    def phone(input)
      phone = input.to_s.sub(/(\d{3})(\d{3})(\d{4})/, "(\\1) \\2-\\3")
      "<a href='tel:#{input}'>#{phone}</a>"
    end
  end
end

Liquid::Template.register_filter(Jekyll::Phone)
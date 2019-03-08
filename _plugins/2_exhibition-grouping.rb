# module Jekyll
#   class ExhibitionCategoryPage < Page
#     def initialize(site, base, dir, title, category)
#       @site = site
#       @base = base
#       @dir = dir
#       @name = category + ".html"

#       self.process(@name)
#       self.read_yaml(File.join(base, '_layouts'), 'exhibitions-category.html')

#       # site.collections['exhibitions_upcoming'] = exhibitions;
#       # self.data['exhibitions_upcoming'] = exhibitions
#       self.data['category'] = category
#       self.data['title'] = title
#     end
#   end

#   class ExhibitionGroupingGenerator < Generator
#     safe true

#     def generate(site)
#       dir = site.config['exhibition_dir'] || 'exhibitions'
#       site.pages << ExhibitionCategoryPage.new(site, site.source, dir, 'Upcoming Exhibitions', 'upcoming')
#       site.pages << ExhibitionCategoryPage.new(site, site.source, dir, 'Past Exhibitions', 'past')
#     end
#   end
# end
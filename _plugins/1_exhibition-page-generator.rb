# module Jekyll
#   class ExhibitionIndexPage < Page
#     def initialize(site, base, dir, exhibition)
#       @site = site
#       @base = base
#       @dir = dir
#       @name = "index.html"

#       self.process(@name)
#       self.read_yaml(File.join(base, '_layouts'), 'exhibitions-show.html')

#       self.data['introduction_text'] = exhibition['introduction_text']

#       self.data['exhibition'] = exhibition
#       self.data['title'] = exhibition['title']
#     end
#   end

#   class ExhibitionIntroductionPage < Page
#     def initialize(site, base, dir, exhibition)
#       @site = site
#       @base = base
#       @dir = dir
#       @name = "introduction.html"

#       self.process(@name)
#       self.read_yaml(File.join(base, '_layouts'), 'exhibitions-introduction.html')

#       self.data['exhibition'] = exhibition
#       self.data['title'] = "Introduction | #{exhibition['title']}"
#     end
#   end

#   class ExhibitionPressReleasePage < Page
#     def initialize(site, base, dir, exhibition)
#       @site = site
#       @base = base
#       @dir = dir
#       @name = "press-release.html"

#       self.process(@name)
#       self.read_yaml(File.join(base, '_layouts'), 'exhibitions-press-release.html')

#       self.data['exhibition'] = exhibition
#       self.data['title'] = "Press Release | #{exhibition['title']}"
#     end
#   end

#   class ExhibitionInstallationViewsPage < Page
#     def initialize(site, base, dir, exhibition)
#       @site = site
#       @base = base
#       @dir = dir
#       @name = "installation-views.html"

#       self.process(@name)
#       self.read_yaml(File.join(base, '_layouts'), 'exhibitions-installation-views.html')

#       self.data['exhibition'] = exhibition
#       self.data['title'] = "Installation Views | #{exhibition['title']}"
#     end
#   end

#   class ExhibitionPublicEngagementPage < Page
#     def initialize(site, base, dir, exhibition)
#       @site = site
#       @base = base
#       @dir = dir
#       @name = "public-engagement.html"

#       self.process(@name)
#       self.read_yaml(File.join(base, '_layouts'), 'exhibitions-public-engagement.html')

#       self.data['exhibition'] = exhibition
#       self.data['title'] = "Public Engagement | #{exhibition['title']}"
#     end
#   end

#   class ExhibitionPageGenerator < Generator
#     safe true

#     def generate(site)
#       dir = site.config['exhibition_dir'] || 'exhibitions'
#       site.collections['exhibitions'].docs.each do |exhibition|
#         index_page = ExhibitionIndexPage.new(site, site.source, File.join(dir, exhibition.basename_without_ext), exhibition)
#         introduction_page = ExhibitionIntroductionPage.new(site, site.source, File.join(dir, exhibition.basename_without_ext), exhibition)
#         press_release_page = ExhibitionPressReleasePage.new(site, site.source, File.join(dir, exhibition.basename_without_ext), exhibition)
#         installation_views_page = ExhibitionInstallationViewsPage.new(site, site.source, File.join(dir, exhibition.basename_without_ext), exhibition)
#         public_engagement_page = ExhibitionPublicEngagementPage.new(site, site.source, File.join(dir, exhibition.basename_without_ext), exhibition)

#         exhibition.data['introduction_url'] = introduction_page.url
#         exhibition.data['press_release_url'] = press_release_page.url
#         exhibition.data['installation_views_url'] = installation_views_page.url
#         exhibition.data['public_engagement_url'] = public_engagement_page.url

#         site.pages << index_page
#         site.pages << introduction_page
#         site.pages << installation_views_page
#         site.pages << press_release_page
#         site.pages << public_engagement_page
#       end
#     end
#   end

# end


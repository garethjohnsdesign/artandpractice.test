module Jekyll
  class CustomCollection < Jekyll::Collection
    def setDirectory(dir)
      @directory = site.in_source_dir(dir)
      @relative_directory = dir
    end
  end
end

module Jekyll
  class Document
    def setCollection(collection)
      @collection = collection
    end
  end
end

module Jekyll
  class NewsCategoryPage < Page
    def initialize(site, base, dir, title, category)
      @site = site
      @base = base
      @dir = dir
      @name = category_kebab(category) + "/index.html"

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'news-list.html')

      self.data['collection_name'] = category_collection_name(category)
      self.data['title'] = title + ' news'
    end
  end
end

def category_kebab(category)
  category.downcase.tr(" ","-")
end

def category_slug(category)
  category.downcase.tr(" ","_")
end

def category_collection_name(category)
  "news_#{category_slug(category)}"
end

Jekyll::Hooks.register :site, :post_read do |site, payload|
  news = site.collections['news']

  recentNewsCollection = Jekyll::CustomCollection.new(site, "news_recent")
  recentNewsCollection.setDirectory("_news")
  site.collections["news_recent"] = recentNewsCollection

  categories = []
  
  news.docs.each do |doc|
    doc['category_tags'].each do |category|
      if category != ''
        categories << category.to_s.downcase
      end
    end
  end

  site.data["news_categories"] = categories.compact.uniq
  
  site.data["news_categories"].each do |category|
    collection = Jekyll::CustomCollection.new(site, category_collection_name(category))
    collection.setDirectory("_news")
    site.collections[category_collection_name(category)] = collection

    site.pages << Jekyll::NewsCategoryPage.new(site, site.source, 'news/', category, category)
  end
end


Jekyll::Hooks.register :site, :pre_render do |site, payload|
  news = site.collections["news"];

  news_recent_payload = payload["site"]["collections"].find { |collection|
    collection["label"] == "news_recent"
  }
  
  collection_payloads = []
  site.data["news_categories"].each do |category|
    collection_payloads << payload["site"]["collections"].find { |collection|
      collection["label"] == category_collection_name(category)
    }
  end

  news_recent_payload["docs"].clear
  collection_payloads.each{ |payload| payload["docs"].clear }

  now = Date.today

  news.docs.each do |doc|
    doc.data['section'] = 'news'
    published_year = doc['published_date'].strftime('%Y')
    published_month = doc['published_date'].strftime('%m')
    published_day = doc['published_date'].strftime('%d')
    doc.data['permalink'] = "/news/#{published_year}/#{published_month}/#{published_day}/:path/"
    doc.data['published_year'] = published_year

    published_date = Date.parse(doc['published_date'].strftime('%Y/%m/%d'))
    ninety_days_ago = (now - 90)

    if published_date > ninety_days_ago
      doc.data['recent'] = true
      news_recent_payload["docs"].push(doc)
    end

    doc['category_tags'].each do |category|
      category_collection_payload = payload["site"]["collections"].find { |collection|
        collection["label"] == category_collection_name(category)
      }
      if category_collection_payload
        category_collection_payload["docs"].push(doc)
      end
    end
  end
end

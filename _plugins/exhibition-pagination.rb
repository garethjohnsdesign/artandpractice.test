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


Jekyll::Hooks.register :site, :after_reset do |site, payload|
  onViewCollection = Jekyll::CustomCollection.new(site, "exhibitions_on_view")
  onViewCollection.metadata['output'] = true
  onViewCollection.metadata['permalink'] = "exhibitions/:path/"

  onViewCollection.setDirectory("_exhibitions")
  site.collections["exhibitions_on_view"] = onViewCollection

  upcomingCollection = Jekyll::CustomCollection.new(site, "exhibitions_upcoming")
  upcomingCollection.metadata['output'] = true
  upcomingCollection.metadata['permalink'] = "exhibitions/:path/"

  upcomingCollection.setDirectory("_exhibitions")
  site.collections["exhibitions_upcoming"] = upcomingCollection

  pastCollection = Jekyll::CustomCollection.new(site, "exhibitions_past")
  pastCollection.metadata['output'] = true
  pastCollection.metadata['permalink'] = "exhibitions/:path/"

  pastCollection.setDirectory("_exhibitions")
  site.collections["exhibitions_past"] = pastCollection
end


Jekyll::Hooks.register :site, :pre_render do |site, payload|
  exhibitions = site.collections["exhibitions"];

  exhibitions_payload = payload["site"]["collections"].find { |collection|
    collection["label"] == "exhibitions"
  }

  exhibitions_on_view_payload = payload["site"]["collections"].find { |collection|
    collection["label"] == "exhibitions_on_view"
  }

  exhibitions_upcoming_payload = payload["site"]["collections"].find { |collection|
    collection["label"] == "exhibitions_upcoming"
  }

  exhibitions_past_payload = payload["site"]["collections"].find { |collection|
    collection["label"] == "exhibitions_past"
  }

  exhibitions_on_view_payload["docs"].clear
  exhibitions_upcoming_payload["docs"].clear
  exhibitions_past_payload["docs"].clear

  now = Time.now.to_i - (60*60*8)

  exhibitions.docs.each do |doc|
    doc.data['section'] = 'exhibitions'
    doc.data['start_date_year'] = doc['start_date'].year

    start_date = doc['start_date'].to_i
    end_date = doc['end_date'].to_i
    range = start_date..end_date

    if range === now
      doc.data['is_active'] = true
      exhibitions_on_view_payload["docs"].push(doc)
    elsif start_date > now
      doc.data['upcoming'] = true
      exhibitions_upcoming_payload["docs"].push(doc)
    else
      doc.data['past'] = true
      exhibitions_past_payload["docs"].push(doc)
    end
  end

  exhibitions_on_view_payload["docs"].each{ |doc|
    doc.setCollection(site.collections["exhibitions_on_view"]);
  }

  exhibitions_upcoming_payload["docs"].each{ |doc|
    doc.setCollection(site.collections["exhibitions_upcoming"]);
  }

  exhibitions_past_payload["docs"].each{ |doc|
    doc.setCollection(site.collections["exhibitions_past"]);
  }
end
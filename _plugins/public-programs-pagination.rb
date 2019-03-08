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
  upcomingCollection = Jekyll::CustomCollection.new(site, "public_programs_upcoming")
  upcomingCollection.metadata['output'] = true
  upcomingCollection.metadata['permalink'] = "public-programs/:path/"

  upcomingCollection.setDirectory("_public_programs")
  site.collections["public_programs_upcoming"] = upcomingCollection

  pastCollection = Jekyll::CustomCollection.new(site, "public_programs_past")
  pastCollection.metadata['output'] = true
  pastCollection.metadata['permalink'] = "public-programs/:path/"

  pastCollection.setDirectory("_public_programs")
  site.collections["public_programs_past"] = pastCollection
end


Jekyll::Hooks.register :site, :pre_render do |site, payload|
  public_programs = site.collections["public_programs"];

  public_programs_upcoming_payload = payload["site"]["collections"].find { |collection|
    collection["label"] == "public_programs_upcoming"
  }

  public_programs_past_payload = payload["site"]["collections"].find { |collection|
    collection["label"] == "public_programs_past"
  }

  public_programs_upcoming_payload["docs"].clear
  public_programs_past_payload["docs"].clear

  now = Time.now.to_i - (60*60*8)

  public_programs.docs.each do |doc|
    doc.data['section'] = 'public-programs'
    doc.data['start_date_year'] = doc['start_date'].year

    start_date = doc['start_date'].to_i
    end_date = doc['end_date'].to_i
    range = start_date..end_date

    if end_date > now
      doc.data['upcoming'] = true
      public_programs_upcoming_payload["docs"].push(doc)
    else
      doc.data['past'] = true
      public_programs_past_payload["docs"].push(doc)
    end
  end

  public_programs_upcoming_payload["docs"].each{ |doc|
    doc.setCollection(site.collections["public_programs_upcoming"]);
  }

  public_programs_past_payload["docs"].each{ |doc|
    doc.setCollection(site.collections["public_programs_past"]);
  }
end

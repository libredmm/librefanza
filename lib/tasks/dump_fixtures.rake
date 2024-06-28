require "open-uri"

def dump_fixture(url, page, dir_name)
  dir = File.absolute_path(
    File.join(
      Rails.root,
      "spec/factories",
      dir_name,
      DateTime.now.strftime("%Y-%m-%d"),
    )
  )
  path = File.join(
    dir,
    Base64.urlsafe_encode64(url, padding: false),
  )
  puts "#{url}\n=> #{path}"
  mkdir_p(dir)
  File.open(path, "w") do |f|
    f.write(page.raw_html)
  end
end

namespace :dump do
  desc "Dump javlibrary page from DB to fixtures"
  task :javlibrary, %i[url] => :environment do |_, args|
    url = args[:url]
    page = JavlibraryPage.find_by!(url: url)
    dump_fixture(url, page, "javlibrary_pages")
  end

  desc "Dump mgstage page from DB to fixtures"
  task :mgstage, %i[url] => :environment do |_, args|
    url = args[:url]
    page = MgstagePage.find_by!(url: url)
    dump_fixture(url, page, "mgstage_pages")
  end

  desc "Dump fc2 page from DB to fixtures"
  task :fc2, %i[url] => :environment do |_, args|
    url = args[:url]
    page = Fc2Page.find_by!(url: url)
    dump_fixture(url, page, "fc2_pages")
  end
end

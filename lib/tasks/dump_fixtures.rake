require "open-uri"

namespace :dump do
  desc "Dump javlibrary page from DB to fixtures"
  task :javlibrary_page, %i[url] => :environment do |_, args|
    url = args[:url]
    page = JavlibraryPage.find_by!(url: url)
    dir = File.absolute_path(
      File.join(
        Rails.root,
        "spec/factories/javlibrary_pages",
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
end

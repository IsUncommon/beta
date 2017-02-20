###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

activate :directory_indexes

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

###
# Helpers
###

# Methods defined in the helpers block are available in templates
helpers do
  def client_list_item(name, url)
    class_name = name.downcase.gsub(/[^0-9a-z]/i, '')
    return "<li class='client-list-item client-#{class_name}'><a href='#{url}'>#{name}</a></li>"
  end

  def client_list
    text = File.read("source/helping/_client_list.html.markdown")
    html = Kramdown::Document.new(text).to_html

    html_doc = Nokogiri::HTML(html)

    html_doc.search('li').each do |item|
      name = item.search('a').inner_text
      class_name = name.downcase.gsub(/[^0-9a-z]/i, '')

      item['class'] = "client-list-item client-#{class_name}"
      image = "<img src='images/client_list/#{class_name}.png' />"
      item << image
    end

    html_doc.search('a').each do |item|
      item['target'] = "_blank"
    end

    html_doc.search('ul')
  end
end

# Build-specific configuration
# Build-specific configuration
configure :build do
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  activate :asset_hash
  # activate :imageoptim


  # Use relative URLs
  activate :relative_assets
end

activate :deploy do |deploy|
  deploy.build_before = true
  deploy.deploy_method = :git
  deploy.branch = "gh-pages"
end


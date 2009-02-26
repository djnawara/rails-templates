# build an rdoc readme
run "rm README; echo \"= Doc needed\" > README.rdoc"

# remove junk files
run "rm -f public/index.html public/favicon.ico public/images/rails.png public/javascripts/*"

# Download JQuery
run "curl -L http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js > public/javascripts/jquery.js"
run "curl -L http://malsup.com/jquery/block/jquery.blockUI.js?v2.10 > public/javascripts/jquery.blockUI.js"
run "curl -L http://github.com/brandonaaron/livequery/raw/master/jquery.livequery.js > public/javascripts/jquery.livequery.js"

# add some more app folders
run "mkdir app/observers app/sweepers app/mailers app/loggers app/sass"

# build our gitingore files
file ".gitignore", <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"

# make this a git repo so we can add submodules
git :init

# ask for edge rails
if yes?("Would you like me to install EdgeRails?")
  rake "rails:freeze:edge"
end

# add the usual submodules
############################
# testing and coverage
plugin "rspec", :git => "git://github.com/dchelimsky/rspec.git", :submodule => true
plugin "rspec_rails", :git => "git://github.com/dchelimsky/rspec-rails.git", :submodule => true
plugin "respec_autotest", :git => "git://github.com/rha7dotcom/rspec_autotest.git", :submodule => true
# cucumber/webrat
plugin "cucumber", :git => "git://github.com/aslakhellesoy/cucumber.git", :submodule => true
plugin "webrat", :git => "git://github.com/brynary/webrat.git", :submodule => true
#authentication
plugin "authlogic", :git => "git://github.com/binarylogic/authlogic.git", :submodule => true
plugin "open_id_authentication", :git => "git://github.com/rails/open_id_authentication.git", :submodule => true
plugin "acts_as_state_machine", :git => "git://github.com/freels/acts_as_state_machine.git", :submodule => true
# code critiqueing tools
plugin "flay", :git => "git://github.com/seattlerb/flay.git", :submodule => true
plugin "flog", :git => "git://github.com/seattlerb/flog.git", :submodule => true
plugin "heckle", :git => "git://github.com/seattlerb/heckle.git", :submodule => true
# pagination
plugin "will_paginate", :git => "git://github.com/mislav/will_paginate.git", :submodule => true
# finish up with our gems
%w(rcov term-ansicolor:term/ansicolor treetop diff-lcs:diff/lcs nokogiri builder libxml-ruby:libxml hpricot ruby-openid:openid).each do |item|
  bidazzle, lib = item.split(":")
  gem bidazzle, (lib.blank? ? {} : {:lib => lib})
end
%w(haml chriseppstein-compass:compass ).each do |item|
  bidazzle, lib = item.split(":")
  gem bidazzle, (lib.blank? ? {} : {:lib => lib}).merge({:source => "http://gems.github.com"})
end
# make sure all of our gems will install
# issues here mean you may need to figure out a lib setting or source
rake "gems:install", :sudo => true
# configure haml
run "haml --rails ."
# configure compass
run "compass --rails -f blueprint --sass-dir app/sass --css-dir public/stylesheets ."
# generator time
generate :rspec
generate :cucumber
# get it all in our fresh repo
git :add => ".", :commit => "-m 'Initial commit.'"

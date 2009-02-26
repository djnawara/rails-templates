run "rm README; echo '= Doc needed' > README.rdoc"
run "rm public/index.html public/rails.png"
git :init
# build our gitingore file
file ".gitignore", <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END
# add the rest of our gitingores
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
# add the usual submodules
if yes?("Do you want to use RSpec?")
  plugin "rspec", :git => "git://github.com/dchelimsky/rspec.git", :submodule
  plugin "rspec_rails", :git => "git://github.com/dchelimsky/rspec-rails.git", :submodule
  plugin "respec_autotest", :git => "git://github.com/rha7dotcom/rspec_autotest.git", :submodule
  gem "rcov"
  generate :rspec
end
if yes?("Do you want to use Cucumber?")
  plugin "cucumber", :git => "git://github.com/dchelimsky/rspec-rails.git", :submodule
  generate :cucumber
end
if yes?("Do you want to use Webrat?")
  plugin "webrat", :git => "git://github.com/brynary/webrat.git", :submodule
  gem "nokogiri"
  gem "libxml-ruby"
  gem "hpricot"
end
if yes?("Do you want to use AuthLogic for authentication?")
  plugin "authlogic", :git => "git://github.com/binarylogic/authlogic.git", :submodule
  plugin "acts_as_state_machine", :git => "git://github.com/freels/acts_as_state_machine.git", :submodule
end
if yes?("Install flay, flog and heckle?")
  plugin "flay", :git => "git://github.com/seattlerb/flay.git", :submodule
  plugin "flog", :git => "git://github.com/seattlerb/flog.git", :submodule
  plugin "heckle", :git => "git://github.com/seattlerb/heckle.git", :submodule
end
plugin "will_paginate", :git => "git://github.com/mislav/will_paginate.git", :submodule
# finish up our gems
gem "nex3-haml", :lib => "haml", :source => "http://gems.github.com"
rake "gems:install"
# get it all in our fresh repo
git :add => ".", :commit => "-m 'Initial commit."

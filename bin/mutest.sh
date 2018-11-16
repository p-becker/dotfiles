#!/bin/bash -e

# Run mutation gem on passed class name
function mutest() {
  /bin/cp -f Gemfile Gemfile.local
  /bin/cp -f Gemfile.lock Gemfile.local.lock
  echo "gem 'mutant-rspec', :group => :test" >> Gemfile.local
  echo "Installing mutant-rspec..."
  BUNDLE_GEMFILE=Gemfile.local bundle install >/dev/null
  BUNDLE_GEMFILE=Gemfile.local RAILS_ENV=test bundle exec mutant -r ./config/environment --use rspec "$1"
}

# Run mutation gem on passed file name
function mutest_file() {
  local class_name
  class_name=$(ag -o "(?<=class\\s)([^\\s]+)" "$1" | head)
  echo "Mapping $1 to $class_name"
  mutest "$class_name"
}

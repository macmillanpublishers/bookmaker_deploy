#! /bin/sh
# # #
ruby ~/bookmaker_local/bookmaker/core/tmparchive/tmparchive_direct.rb $1 direct "test.name@test.com" "Test User" "test.name@test.com" "Test User"
ruby ~/bookmaker_local/bookmaker_addons/htmlmaker_preprocessing.rb $1 direct "test.name@test.com" "Test User"
ruby ~/bookmaker_local/bookmaker/core/htmlmaker/htmlmaker.rb $1 direct "test.name@test.com" "Test User"
ruby ~/bookmaker_local/bookmaker_addons/htmlmaker_postprocessing.rb $1 direct "test.name@test.com" "Test User"
ruby ~/bookmaker_local/covermaker/bookmaker_titlepage.rb $1 direct "test.name@test.com" "Test User"
ruby ~/bookmaker_local/bookmaker_addons/metadata_preprocessing.rb $1 direct "test.name@test.com" "Test User"
ruby ~/bookmaker_local/bookmaker/core/filearchive/filearchive.rb $1 direct "test.name@test.com" "Test User"
ruby ~/bookmaker_local/bookmaker_addons/filearchive_postprocessing.rb $1 direct "test.name@test.com" "Test User"
ruby ~/bookmaker_local/bookmaker/core/imagechecker/imagechecker.rb $1 direct "test.name@test.com" "Test User"
ruby ~/bookmaker_local/bookmaker_addons/imagechecker_postprocessing.rb $1 direct "test.name@test.com" "Test User"
# ruby ~/bookmaker_local/covermaker/bookmaker_covermaker.rb $1 direct "test.name@test.com" "Test User"
# ruby ~/bookmaker_local/bookmaker/core/coverchecker/coverchecker.rb $1 direct "test.name@test.com" "Test User"
ruby ~/bookmaker_local/bookmaker/core/stylesheets/stylesheets.rb $1 direct "test.name@test.com" "Test User"
ruby ~/bookmaker_local/bookmaker_addons/pdfmaker_preprocessing.rb $1 direct "test.name@test.com" "Test User"
ruby ~/bookmaker_local/bookmaker/core/pdfmaker/pdfmaker.rb $1 direct "test.name@test.com" "Test User"
# ruby ~/bookmaker_local/bookmaker_addons/epubmaker_preprocessing.rb $1 direct "test.name@test.com" "Test User"
# ruby ~/bookmaker_local/bookmaker/core/epubmaker/epubmaker.rb $1 direct "test.name@test.com" "Test User"
# ruby ~/bookmaker_local/bookmaker_addons/epubmaker_postprocessing.rb $1 direct "test.name@test.com" "Test User"
# ruby ~/bookmaker_local/bookmaker_addons/cleanup_preprocessing.rb $1 direct "test.name@test.com" "Test User"
# ruby ~/bookmaker_local/bookmaker/core/cleanup/cleanup.rb $1 direct "test.name@test.com" "Test User"

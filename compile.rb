require 'json'

# requires path of the parent folder where your deploy scripts live e.g. .. or "Users/nelliemckesson/git"
unescapeargv = ARGV[0].chomp('"').reverse.chomp('"').reverse
scripts_dir = File.expand_path(unescapeargv)
scripts_dir = scripts_dir.split(Regexp.union(*[File::SEPARATOR, File::ALT_SEPARATOR].compact)).join(File::SEPARATOR)

# The addon files JSON
file = File.join(scripts_dir, "bookmaker_deploy", "scripts.json")
json = File.read(file)
deploy_hash = JSON.parse(json)

# figure out which addon files to apply
projects = []

headerfile = File.join(scripts_dir, "bookmaker_deploy", "templates", "_header.bat")
midfile = File.join(scripts_dir, "bookmaker_deploy", "templates", "_mid.bat")
footerfile = File.join(scripts_dir, "bookmaker_deploy", "templates", "_footer.bat")
loggerline = ">> %logfile% 2>&1 && call :ProcessLogger"

rubycmd = "C:\\Ruby200\\bin\\ruby.exe"
corepath = "S:\\resources\\bookmaker_scripts\\bookmaker\\core"
addonspath = "S:\\resources\\bookmaker_scripts\\bookmaker_addons"
pitstoppath = "S:\\resources\\bookmaker_scripts\\pitstop_watch"

deploy_hash['projects'].each do |p|
  filename = p['name']
  filepath = File.join(scripts_dir, "bookmaker_deploy", "#{filename}")

  header = File.read(headerfile)
  mid = File.read(midfile)
  footer = File.read(footerfile)

  scripts = p['scripts']

  unless p['processwatch'] == true
    header = ""
  end

  File.open(filepath, 'w+') do |f|
    f.puts header
  end

  scripts.each do |s|
    deploy_hash['scripts'].each do |f|
      if f['name'] == s['name']
        processwatcher = "  echo #{f['testvalue']}"
        File.open(filepath, 'a+') do |f|
          f.puts processwatcher
        end
      end
    end
  end

  if p['statuscheck'] == true
    mid = mid.gsub(/REM STATUSHERE/, "echo status_check")
  else
    mid = mid.gsub(/REM STATUSHERE/, '')
  end

  unless p['processwatch'] == true
    mid = ""
  end

  File.open(filepath, 'a+') do |f|
    f.puts mid
  end

  scripts.each do |s|
    deploy_hash['scripts'].each do |f|
      if f['name'] == s['name']
        runcommand = "#{f['command']} #{f['location']} #{f['argv']}#{loggerline} #{f['testvalue']}"
        runcommand = runcommand.gsub(/RUBYCMD/,rubycmd).gsub(/BKMKRCORE/,corepath).gsub(/BKMKRADDONS/,addonspath).gsub(/PITSTOP/,pitstoppath).gsub(/\s\s/," ")
        File.open(filepath, 'a+') do |f|
          f.puts runcommand
        end
      end
    end
  end

  unless p['processwatch'] == true
    footer = ""
  end

  statusline = "#{rubycmd} S:\\resources\\bookmaker_scripts\\utilities\\bookmaker_status_checker.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger status_check"

  if p['statuscheck'] == true
    footer = footer.gsub(/REM STATUSHERE/,statusline)
  else
    footer = footer.gsub(/REM STATUSHERE/,"")
  end

  File.open(filepath, 'a+') do |f|
    f.puts footer
  end
end
require 'date'
require 'optparse'
require 'sensr'
require 'fileutils'
require 'net/http'
require 'uri'
require 'pp'

# See http://yacc.github.io/sensrapi-tutorials/ for how to get a token
load 'mytoken.rb' # replace with Sensr.oauth_token = 'mytoken...' 
# Sensr.oauth_token = 'mytoken...'  

options = {}
optparse = OptionParser.new do|opts|
  opts.banner = "Usage: get-images [options]"

# support -d all
  options[:date] = nil
  opts.on( '-d', '--date yyyy-mm-dd', 'Date grab the images from [year-month-day]' ) do |date| # TODO add optional month and day
    if m = date.match(/^(\d{4})-(\d\d?)-(\d\d?)$/)
      year = m[1]
      month = m[2]
      day = m[3]

      options[:date] =  Time.utc(year,month,day).to_i 
    else
      puts "Exception: Error in specified date '#{date}'. Exiting."
      exit
    end
  end
  
  options[:dir] = nil
  opts.on( '-P', '--directory-prefix name', 'directory destination for the output' ) do |dir| 
    if m = dir.match(/[^\s+]/)
      options[:dir] = dir
    else
      puts "Exception: Error in specified camera, must be an int '#{cam}'. Exiting."
      exit
    end
  end
    
  options[:camera] = nil
  opts.on( '-c', '--cam n', 'Camera id to pull images from [n]' ) do |cam| 
    if m = cam.match(/^(\d+)$/)
      num = m[1]
      options[:camera] =  num.to_i
    else
      puts "Exception: Error in specified camera, must be an int '#{cam}'. Exiting."
      exit
    end
  end
  
  options[:verbose] = false
  opts.on( '-v', '--verbose', 'Output more information (debug)' ) do
    options[:verbose] = true
  end

  opts.on( '-h', '--help', 'display this help' ) do
    puts opts
    exit
  end
end

# return a no clobber version of the name
def no_clobber(name)
  return name unless File.exists?(name)
  (1..255).each { |v| n = "#{name}.#{v}"; return n unless File.exists?(n) }
end

# get the url and put it in the dir with the filename
def wget(dir, url, fname)
  u = URI.parse(url)
  # create the directory if it doesn't exist
  FileUtils.mkdir_p(dir) unless File.exists?(dir)
  fname = no_clobber("#{dir}/#{fname}")
  begin
    f = File.open(fname, 'w') # TODO implement wget naming in case file exists...  foo.1 foo.2 ...
    Net::HTTP.start(u.host) do |http|
      http.request_get(u.path) do |resp|
        resp.read_body do |segment|
          f.write(segment)
        end
      end
    end
  ensure
    f.close()
  end

end

begin
  
  optparse.parse!
  puts "Verbose debug on ..." if options[:verbose]
  
  # use camera 88 if none provided, it's public
  options[:camera] = 88 if options[:camera].nil?
  cam_id = options[:camera]
  
  # use yesterday if no date
  options[:date] = (Time.now - 86400).to_i if options[:date].nil?
  date = options[:date]

  # use the local dir if not specified
  options[:dir] = '.' if options[:dir].nil?
  dir = options[:dir]
    
  if options[:verbose] then
    puts "finding images for camera #{cam_id} on day #{Time.at(date).to_datetime}"
  end
  
  c = Sensr::Camera.find(cam_id)

  day =  c.day(date)
  day["day"]["hours"].each do |hour|
    time = hour["hour"]["epoch_time"]
    c.hour(time)["hour"]["images"].each { |i| wget(options[:dir],i['url'],"#{Time.at(i['taken_at']).to_s.gsub(/\s/,'+')}.jpg") }
  end

end
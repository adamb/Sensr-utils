require 'date'
require 'optparse'
require 'sensr'
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

begin
  
  optparse.parse!
  puts "Verbose debug on ..." if options[:verbose]
  
  # use camera 88 if none provided, it's public
  options[:camera] = 88 if options[:camera].nil?
  cam_id = options[:camera]
  
  # use today if no date
  options[:date] = (Time.now - 86400).to_i if options[:date].nil?
  date = options[:date]
  
  if options[:verbose] then
    puts "finding images for camera #{cam_id} on day #{Time.at(date).to_datetime}"
  end
  
  c = Sensr::Camera.find(cam_id)

  day =  c.day(date)
  day["day"]["hours"].each do |hour|
    time = hour["hour"]["epoch_time"]
    c.hour(time)["hour"]["images"].each { |i| puts "wget #{i['url']} -O #{Time.at(i['taken_at']).to_s.gsub(/\s/,'+')}.jpg" }
  end

end
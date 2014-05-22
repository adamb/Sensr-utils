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
    if m = date.match(/^(\d{4})-(\d\d)-(\d\d)$/)
      year = m[1]
      month = m[2]
      day = m[3]

      options[:date] =  Time.utc(year,month,day)
    else
      puts "Exception: Error in specified duration '#{date}'. Exiting."
      exit
    end
  end
  
  opts.on( '-e', '--end-date yyyy-mm-dd', 'End date to grab the images from [year-month-day]|' ) do |date| # TODO add optional month and day
    if m = date.match(/^(\d{4})-(\d\d)-(\d\d)$/)
      year = m[1]
      month = m[2]
      day = m[3]

      options[:end_date] =  Time.utc(year,month,day)
    else
      puts "Exception: Error in specified duration '#{date}'. Exiting."
      exit
    end
  end
  
  options[:camera] = nil
  opts.on( '-c', '--cam n', 'Camera id to pull images from [n]' ) do |cam| 
    if m = cam.match(/^(\d+)/)
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
  
  

  target_camera     = ARGV[0].to_i

  c = Sensr::Camera.find(5)

  day =  c.day(Time.now.to_i)
  day["day"]["hours"].each do |hour|
    time = hour["hour"]["epoch_time"]
    c.hour(time)["hour"]["images"].each { |i| puts "wget #{i['url']}" }
  end

end
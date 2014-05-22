require 'optparse'
require 'sensr'
require 'pp'

# See http://yacc.github.io/sensrapi-tutorials/ for how to get a token
load 'mytoken.rb' # replace with Sensr.oauth_token = 'mytoken...' 
# Sensr.oauth_token = 'mytoken...'  

options = {}
optparse = OptionParser.new do|opts|
  opts.banner = "Usage: get-latest [options]"

# support -d all
  options[:image] = nil
  opts.on( '-i', '--image', 'Return URL for the latest image' ) do 
      options[:image] =  'latestimage'
  end
  
  options[:stream] = nil
  opts.on( '-s', '--stream', 'Return URL for the MJPEG stream' ) do 
      options[:stream] =  'livestream'
  end
  
  options[:camera] = nil
  opts.on( '-c', '--cam n', 'Camera id [n]' ) do |cam| 
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

  
  if options[:verbose] then
    puts "finding latest #{options[:image]} #{options[:stream]} for camera #{cam_id}"
  end
  
  c = Sensr::Camera.find(cam_id)

  

  # the last image that we've saved to S3
  puts "#{c.attributes['urls']['latestimage']}" if options[:image]  # this is a jpeg
  puts "#{c.attributes['urls']['livestream']}" if options[:stream]  # this is mjpeg

end

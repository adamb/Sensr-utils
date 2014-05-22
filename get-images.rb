require 'sensr'
require 'pp'
load 'mytoken.rb' # SSensr.oauth_token = 'mytoken...'  See http://yacc.github.io/sensrapi-tutorials/ for how to get a token


target_camera     = ARGV[0].to_i

c = Sensr::Camera.find(5)

day =  c.day(Time.now.to_i)
day["day"]["hours"].each do |hour|
  time = hour["hour"]["epoch_time"]
  c.hour(time)["hour"]["images"].each { |i| puts "wget #{i['url']}" }
end


# Sensr-utils

We get a lot of requests for features that can be implemented using the Sensr API.  I decided to start
creating some utils that use the API with the hope that our users can extend these or maybe even create
better versions of them.  The first one I'm doing is called get-images.rb and it will pull down the images
from a Sensr.net camera.

## get-images.rb

This will grab the images from a Sensr.net camera and place them into the specified directory. 

	$ ruby get-images.rb --help
	Usage: get-images [options]
	    -d, --date yyyy-mm-dd            Date grab the images from [year-month-day]
	    -P, --directory-prefix name      directory destination for the output
	    -c, --cam n                      Camera id to pull images from [n]
	    -v, --verbose                    Output more information (debug)
	    -h, --help                       display this help

The output would look something like this:

	$ ruby get-images.rb -c 5 -d 2014-05-01 -P mayday
	$ ls mayday
	2014-04-30+00:03:22+-0700.jpg   2014-04-30+06:04:06+-0700.jpg   2014-04-30+12:04:50+-0700.jpg   2014-04-30+18:05:14+-0700.jpg
	2014-04-30+01:03:23+-0700.jpg   2014-04-30+07:04:17+-0700.jpg   2014-04-30+13:04:51+-0700.jpg   2014-04-30+19:05:15+-0700.jpg
	2014-04-30+02:03:33+-0700.jpg   2014-04-30+08:04:17+-0700.jpg   2014-04-30+14:05:02+-0700.jpg   2014-04-30+20:05:15+-0700.jpg
	2014-04-30+03:03:34+-0700.jpg   2014-04-30+09:04:28+-0700.jpg   2014-04-30+15:05:02+-0700.jpg   2014-04-30+21:05:36+-0700.jpg
	2014-04-30+04:03:45+-0700.jpg   2014-04-30+10:04:39+-0700.jpg   2014-04-30+16:05:03+-0700.jpg   2014-04-30+22:05:47+-0700.jpg
	2014-04-30+05:03:56+-0700.jpg   2014-04-30+11:04:39+-0700.jpg   2014-04-30+17:05:14+-0700.jpg   2014-04-30+23:05:37+-0700.jpg
	
The images from camera 5 that were saved on May 1st, 2014 are stored in the directory mayday. The images are named with the time they were taken.

### Improvements for get-images.rb

* Not require the user to have their own token, but get it with a password
* Grab the favorites from a camera
* Grab the clips from a camera

## get-latest.rb

If you want to find the latest JPEG image that has been uploaded or the MJPEG stream for a given camera, this will find it.
Note that these URLs change occasionally and without warning, mainly for load balancing. You could use the `--image` URL to give 
to [Weather Underground][wundercam].

	$ ruby get-latest.rb  --help
	Usage: get-latest [options]
	    -i, --image                      Return URL for the latest image
	    -s, --stream                     Return URL for the MJPEG stream
	    -c, --cam n                      Camera id [n]
	    -v, --verbose                    Output more information (debug)
	    -h, --help                       display this help

Here's an example that returns the latest image and stream for camera 88.

	$ ruby get-latest.rb  --image --stream --cam 88
	http://fxp6.sensr.net/latest/3aee7a35b90f64749d7634e0366b5170553a0787
	http://fxp6.sensr.net/stream/3aee7a35b90f64749d7634e0366b5170553a0787

**Warning:** these URLs are only protected by the random URL. If you give it out, it will work _even for private cameras._ So be careful 
where you place the URLs once you discover them!


## Other ideas?

* Gif generator
* Time lapse generator
* Composite image from all your cameras 
* Create a [Weather Underground][wundercam] link for a camera that doesn't change


Thanks to [Yacin][yacc] for [creating this API][tutorial] in the first place! 


[tutorial]: http://yacc.github.io/sensrapi-tutorials/
[yacc]: http://www.linkedin.com/in/yacinbahi
[wundercam]: http://www.wunderground.com/webcams/signup.html#addcam

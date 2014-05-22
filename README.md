# Sensr-utils

We get a lot of requests for features that can be implemented using the Sensr API.  I decided to start
creating some utils that use the API with the hope that our users can extend these or maybe even create
better versions of them.  The first one I'm doing is called get-images.rb and it will pull down the images
from a Sensr.net camera.

## get-images.rb

This will grab the images from a Sensr.net camera and generate the wget commands to retrieve them. 

	$ ruby get-images.rb --help
	Usage: get-images [options]
	    -d, --date yyyy-mm-dd            Date grab the images from [year-month-day]
	    -c, --cam n                      Camera id to pull images from [n]
	    -v, --verbose                    Output more information (debug)
	    -h, --help                       display this help

The output would look something like this:

	$ ruby get-images.rb -c 5 -d 2014-05-01
	wget https://s3.amazonaws.com/sensrnet-cams/f6aaac5fe6452a775f7c990b4e9dcac11f140438.jpg -O 2014-04-30+00:03:22+-0700.jpg
	wget https://s3.amazonaws.com/sensrnet-cams/cfc84e01a83d1cce085000bf5025baa8a4b12d5c.jpg -O 2014-04-30+01:03:23+-0700.jpg
	wget https://s3.amazonaws.com/sensrnet-cams/ee8d309ca8ca650b61e4d85d313165e4c85f9df5.jpg -O 2014-04-30+02:03:33+-0700.jpg
	wget https://s3.amazonaws.com/sensrnet-cams/9051771f1fe69c48bcb5a148422b2aed1af272ee.jpg -O 2014-04-30+03:03:34+-0700.jpg
    ....

To actually grab all these images, you'll have to cut and paste the output into a terminal and it will grab the images from S3 and 
store them into files names with the time and date that they were taken. Next step would be to add an option for the script to 
download the files directly, but for now this will work.

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

**Warning** these URLs are only protected by the random URL. If you give it out, it will work _even for private cameras._ So be careful 
where you place the URLs once you discover them!


## Other ideas?

* Gif generator
* Time lapse generator
* Create a Weather Underground link for a camera


Thanks to [Yacin][yacc] for [creating this API][tutorial] in the first place! 


[tutorial]: http://yacc.github.io/sensrapi-tutorials/
[yacc]: http://www.linkedin.com/in/yacinbahi
[wundercam]: http://www.wunderground.com/webcams/signup.html#addcam

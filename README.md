varnish Dockerfile
=======

The experiment of putting the varnish in front of your web app via container environment.


---------------

## Usage  ##

 - Modify the ***docker-compose.yml*** file to link the appropriate web app container.
 
 - Modify the ***varnish.vcl*** file to meet your backend app setting and caching policy.
 
 - Run ` docker-compose up`
 
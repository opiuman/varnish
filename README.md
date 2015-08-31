varnish Dockerfile
=======

The experiment of putting the varnish in front of your web app via container environment.


---------------

## Usage  ##

 - Modify the ***docker-compose.yml*** file to link the appropriate backend container.
 
 - Modify the ***varnish.vcl*** file to meet your backend container setting and caching policy.
 
 - Run ` docker-compose up`
 

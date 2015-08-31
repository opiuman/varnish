vcl 4.0;

backend default {
  .host = "backend";
  .port = "3000";
}
#access control list for purge/ban ips
acl purge {
  "localhost";
  "192.168.99.100"/24;
}
# http purge
# sub vcl_recv {
#      if (req.method == "PURGE") {
#              if (!client.ip ~ purge) {
#               	return(synth(405,"Not allowed."));
#             }
#         return (purge);
#     }
# }

# http ban
sub vcl_recv {
  if (req.method == "BAN") {
    # Same ACL check as above:
    if (!client.ip ~ purge) {
            return(synth(403, "Not allowed."));
    }
    ban("req.http.host == " + req.http.host +
          " && req.url == " + req.url);

    # Throw a synthetic page so the
    # request won't go to the backend.
    return(synth(200, "Ban added"));
  }
  set req.http.X-Forwarded-For = client.ip;
  # remove double // in urls,
  set req.url = regsuball( req.url, "//", "/"      );
}

sub vcl_deliver {
  # Set a header to track a cache HIT/MISS.
  if (obj.hits > 0) {
    set resp.http.X-Varnish-Cache = "HIT";
  }
  else {
    set resp.http.X-Varnish-Cache = "MISS";
  }
}

sub vcl_backend_response {
  # Not cache 400 - 500 status requests
  if (beresp.status >= 400 && beresp.status <= 600) {
        set beresp.ttl = 0s;
  }
    #Remove cookies 
  unset beresp.http.set-cookie;
       
  # Remove Expires from backend 
  unset beresp.http.expires;

  # Set the clients TTL on this object DEFAULT 
  set beresp.http.cache-control = "max-age=3600";

  # Set how long Varnish will keep it (default is 120s)
  set beresp.ttl = 3600s;
}

# matrix-invite-panel

An invite token system for Synapse, inspired by
[matrix-registration](https://github.com/zeratax/matrix-registration), with some new additions:

- A web frontend for issues new invites or revoking previously issued ones.
- Automated invite expiration.
- Looks pretty! With easily customizable looks and colors.

![Registration page](images/register.png)
![Invites page](images/invites.png)

## Setup

**NOTE:** As this is a brand-new project, these instructions may not be 100% perfect. They will
be refined as time passes and my own instance is refined.

### Background

matrix-invite-panel requires three components to run:

-  A gRPC-powered backend.
-  An AngularDart-powered frontend.
-  A gRPC-web proxy to allow the frontend to talk to the backend.

### Backend

#### Docker

A premade, nightly-rebuilt Docker image is available of the backend at
`gcr.io/refi64/matrix-invite-panel` (built using the Dockerfile in this repository).
All you need to do is mount the config file inside (see the below section), mount a
storage path, pass the path as an argument, and expose the ports. Example:

```bash
# Assuming that config.yaml has the server running on port 9090
# and that the storage directory is /storage
$ docker run --rm -it -p 9090:9090 -v $PWD/config.yaml:/app/config.yaml -v $PWD/storage:/storage \
  gcr.io/refi64/matrix-invite-panel config.yaml
```

#### Running by hand

Make sure a recent version of [Dart](https://dart.dev/) is installed, then cd into
`backend` and run `pub get` and `dart bin/backend.dart CONFIG_FILE` to get started.
Note that, if you want faster boot time or more consistent performance, you can compile
the backend using dart2native and run the resulting binary (see the Dockerfile for an
example).

#### Configuration

Please see `backend/config.ex.yaml` for an example configuration file.

### gRPC Proxy

The gRPC protocol goes over raw HTTP/2, which a browser can't talk to. Therefore, a
proxy server must be run to convert between the native gRPC format that the backend
speaks and the gRPC-web format.

Although the official guidance seems to be leaning towards using Envoy, I honestly
could not make it work, and after spending an hour with 50 lines of YAML soup I gave
up and switched to the far simpler
[grpcwebproxy](https://github.com/improbable-eng/grpc-web/tree/master/go/grpcwebproxy)
instead. I have Docker images built nightly
([source](https://bk.refi64.com/cloud/containers/grpcwebproxy/?PAGE=dir)), available
at `gcr.io/refi64/grpcwebproxy`, or you can build and run it yourself. The arguments
are documented at the grpcwebproxy page.

#### Rate limiting

It's recommended to have some form of rate limiting in front of grpcwebproxy, e.g.
50 requests per minute, to avoid having people trying to hammer the login forms.
How you do this is up to you; as I generally use k8s, my preference would be using
the NGINX ingress controller's built-in rate limiting functionality.

### Frontend

#### Configuration

There are two files two configure the frontend: `frontend/web/config.json`
and `frontend/web/_config.scss`. Both have example files available as
`config.ex.json` and `_config.ex.scss` respectively; see those files for more details.

Please note that the backend server URL here should be pointing to grpcwebproxy, not
directly to the underlying backend server itself.

Note that, **without the config files present, the frontend will *not* build**.

#### Building

The frontend is a static site, written in AngularDart. Grab [Dart](https://dart.dev), and
run:

```
$ cd frontend
$ pub global activate webdev
$ webdev build
```

to build it and drop the files in the `build` folder.

#### Hosting

From here, it's your choice where to place the files. Do note that this uses a history-based
SPA routing strategy, which essentially means that your web server needs to redirect not-found
files to `index.html`. You can generally google something like *"spa my-web-server"* or similar
to find out how to do this.

The absolute simplest way would be to not host it yourself, rather relying on an online service.
GitHub Pages would not work due to the routing requirement, but [Netlify](https://www.netlify.com/)
or [Firebase](https://firebase.google.com/) (which is what I use) would both be excellent choices.

There's a quick overview of the routing mentioned above
[here](https://www.netlify.com/blog/2020/04/07/creating-better-more-predictable-redirect-rules-for-spas/)
for Netlify and [here](https://firebase.google.com/docs/hosting/full-config#rewrites) for Firebase.

As an added performance boost, you could use HTTP/2 push to send over the main.dart.js and styles.css
files along with index.html in one swoop. This is again host-dependent and is definitely outside of
the scope of this guide, as it's not really a must-have overall (despite being really cool).

### Example setup

To bring it all together, let's assume we're using:

- The Docker image of the backend
- grpcwebproxy
- Some SSL-enabled reverse proxy
- Hosting the static site on Firebase

First off, let's create a Docker network so the proxy can talk to the gRPC backend:

```
$ docker network create matrix-invite-panel
```

Your backend config file might look like this:

```yaml
port: 9090
database_path: /app/storage
# yes I just rammed into the keyboard, please use an actual secure RNG for this secret!
jwt_secret: kasdjlaskjdas;lfsd
homeserver:
  url: https://matrix.my-home.server
  # This would again be taken from your Synapse instance's homeserver.yaml file
  registration_secret: a;fajsdflksdafjdsl;fasd
```

This will start the backend server on port 9090. Now I'll run:

```bash
$ docker run --rm -it --net matrix-invite-panel --name matrix-invite-panel \
  -v $PWD/config.yaml:/app/config.yaml:z \
  -v $PWD/storage:/app/storage:z \
  gcr.io/refi64/matrix-invite-panel /app/config.yaml
```

Next comes grpcwebproxy, running on port 8081:

```bash
$ docker run --rm -it --net matrix-invite-panel -p 8081:8081 --name grpcwebproxy \
  --server_http_debug_port=8081 --backend_addr=matrix-invite-panel:9090 \
  --backend_tls_noverify --run_tls_server=false \
  --allowed_origins https://MY-FRONTEND-URL/
```

Note that, as the two containers are running on the same network, there's no need for
TLS between them, thus the --backend_tls_noverify. In addition, you would likely want
SSL certificates active on grpcwebproxy if you're *not* using a reverse proxy. However,
as there *is* a reverse proxy, the reverse proxy is what will be handling TLS, thus
grpcwebproxy itself runs unencrypted. (That's a lot of proxies...)

Your frontend config may then look like:

```json
{
  "backend": "https://my-server.com:8081",
  "homeserver": {
    "url": "https://matrix.home.server/",
    "name": "home.server"
  }
}
```

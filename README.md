# ANDI
Another Nginx Docker Image

<br/>

## Why another Nginx Docker Image?

There are several Nginx docker images available, but sometimes we need to tweak in the tiniest details of Nginx. This utility allows building Nginx from its sources with custom configuration and create minimal size docker image (`19.7M`).

<br/>

## Usage
### Tweaking the custom build options
The custom build options for Nginx are stored in `build.sh` and can be changed as per the requirements.

Nginx build options can be referenced from [here](http://nginx.org/en/docs/configure.html)

<br/>

### Building the base image

* Run the following command in the root of this repository

  ``
  docker image build -t mynginx:base --build-arg NGINX_VERSION=1.18.0 .
  ``

* Pass in the argument `NGINX_VERSION` to set the target Nginx version. Available versions can be found from [here](http://nginx.org/en/download.html)
* Set the appropriate tag for the image.

<br/>

### Testing the base image

* Run the following command

  ``
  docker container run -d -p 8080:8080 mynginx:base
  ``
  
* Visit `localhost:8080` on your local browser to see the basic Nginx welcome page.

<br/>

### Using the custom image for your projects

* In your `nginx.conf` file, set the root as `/app`.
* Assets can be served from this image using one of the following ways
  1. Creating a new image with assets

      ```
      FROM mynginx:base
      COPY ./assets /app
      COPY ./nginx.conf /usr/share/nginx/conf/nginx.conf
      EXPOSE 8080
      ```

  2. Exposing assets as volume

      ```
      docker container run -d -p 80:8080 \
      -v $(pwd)/mysite/assets:/app \
      -v $(pwd)/mysite/nginx.conf:/usr/share/nginx/conf/nginx.conf \
      mynginx:base
      ```

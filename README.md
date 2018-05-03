# docker-legacy-v1

Docker file for building a container that will run the TurboPatent legacy V1
authoring server and web app.

## Building

The build needs access to the some private git repositories, so when building
the docker image, you need to supply an SSH private key that grants git+ssh
access to those repositories. So, building should be done something like

```
$ docker build . --build-arg SSH_PRIVATE_KEY="`cat ~/.ssh/id_rsa`"
```

## Running

The container needs access to the legacy v1 RDS database running in the AWS
cloud. All of the credentials are configured in the image except the password,
which needs to be specified in the `DB_PASSWORD` environment variable.

The container also needs access to the S3 media bucket via an access key, which
is specified in the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment
variables.

The farnsworth server listens on port 8000 and the web applications listen on
ports 4200 and 4700, so those ports need to be mapped when running the image.
So, running should be done something like

```
$ docker run -e DB_PASSWORD='<password>' -e AWS_ACCESS_KEY_ID=<AWS key id> -e AWS_SECRET_ACCESS_KEY=<AWS key secret> -p 8005:8000 -p 4205:4200 -p 4705:4700 <image>
```

The visit `http://<org-domain>.localhost:8005/signin/` to log in,
`http://<org-domain>.localhost:4705/home` to go to the home screen, or
`http://<org-domain>.localhost:4205` to go to the v1 authoring inbox.

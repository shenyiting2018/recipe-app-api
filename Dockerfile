FROM python:3.7-alpine
MAINTAINER Yiting

# Set an environment variable, tell python in unbuffer mode
ENV PYTHONUNBUFFERED 1

# Copy file from current repo to docker image
COPY ./requirements.txt /requirements.txt
# use package mangement tool: apk to install postgresql-client
RUN apk add --update --no-cache postgresql-client
#
RUN apk add --update --no-cache --virtual .tmp-build-deps \
    gcc libc-dev linux-headers postgresql-dev
# Install all requirements
RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps

RUN mkdir /app
# Change working dir
WORKDIR /app
# Copy ./app from local machine to image
COPY ./app app

# Create a user, this user only runs application by -D. This is for security,
# otherwise running with root permission
RUN adduser -D user
# Switch to the user
USER user

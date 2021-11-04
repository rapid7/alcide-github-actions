#FROM python:3.8-alpine
FROM python
MAINTAINER Rotem Jackoby
LABEL Version="1.0"

RUN pip install slack_sdk
# Copy just the requirements.txt first to leverage Docker cache
COPY ./requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install -r requirements.txt
COPY . /app

RUN chmod +x entrypoint.sh

#ENTRYPOINT ["/app/entrypoint.sh"]
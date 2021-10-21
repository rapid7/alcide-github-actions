FROM python:3.8-alpine
MAINTAINER r7-csp-ops
LABEL Version="1.0"

RUN pip install slack_sdk
# We copy just the requirements.txt first to leverage Docker cache
COPY ./requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install -r requirements.txt
COPY . /app
CMD [ "app.py" ]
ENTRYPOINT [ "python" ]
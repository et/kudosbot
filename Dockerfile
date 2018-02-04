
FROM markadams/chromium-xvfb
WORKDIR /usr/src/app

RUN apt-get install -y ruby bundler git

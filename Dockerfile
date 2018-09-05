FROM ubuntu:14.04 as base

RUN apt-get update && apt-get install -y \
  openssh-client \
  apt-transport-https \
  sudo \
  vim \
  curl \
  git

# Node 6 repo
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

# Yarn repo
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y \
  nodejs \
  yarn

FROM base as intermediate

ARG SSH_PRIVATE_KEY
RUN mkdir /root/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN git clone git+ssh://git@github.com/PatentNavigation/farnsworth
RUN git clone git+ssh://git@github.com/PatentNavigation/farnsworth-web
RUN git clone git+ssh://git@github.com/PatentNavigation/terry

# Install node dependencies while we have our ssh private key so we can access
# private repos
WORKDIR /farnsworth
RUN git checkout legacy-v1
RUN yarn
WORKDIR /farnsworth-web
RUN git checkout legacy-v1
RUN yarn
WORKDIR /terry
RUN git checkout legacy-v1
RUN yarn

FROM base

USER root

RUN apt-get update && apt-get install -y \
  # base python/pip/virtualenv packages
  python-setuptools \
  build-essential \
  python-pip \
  python-virtualenv \
  python-dev \
  libffi-dev \
  libxml2-dev \
  libxslt1-dev \
  # DB-related packages
  python-mysqldb \
  mysql-client \
  libmysqlclient-dev \
  # farnsworth-specific packages
  libssl-dev \
  ghostscript \
  pdftk \
  # packages needed for testing
  imagemagick

RUN useradd -ms /bin/bash djuser
RUN echo "djuser:djuser" | chpasswd
RUN adduser djuser sudo

USER djuser
WORKDIR /home/djuser

COPY --chown=djuser --from=intermediate /farnsworth /home/djuser/farnsworth
COPY --chown=djuser --from=intermediate /farnsworth-web /home/djuser/farnsworth-web
COPY --chown=djuser --from=intermediate /terry /home/djuser/terry

WORKDIR /home/djuser/farnsworth
RUN virtualenv ~/venv

ENV PATH="/home/djuser/venv/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN yarn bower

WORKDIR /home/djuser/farnsworth-web
RUN yarn bower

COPY --chown=djuser local_settings.py /home/djuser/farnsworth/farnsworth/local_settings.py
COPY --chown=djuser run.sh /home/djuser

WORKDIR /home/djuser
EXPOSE 8000
EXPOSE 4200
EXPOSE 4700
CMD ./run.sh

FROM docker:1.13

# Install dependecies
RUN set -x \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk add --no-cache \
      bash \
      curl \
      py2-pip \
      kubernetes \
  && pip install awscli \
  && pip install docker-compose \
  && docker-compose --version \
  && kubectl version --client

# Install Helm - https://github.com/kubernetes/helm/blob/master/docs/install.md#from-script
ENV HELM_VERSION 2.2.2

RUN set -ex \
  && curl -fSL -o helm.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
  && tar -xzvf helm.tar.gz \
  && mv linux-amd64/helm /usr/local/bin/ \
  && rm -rf linux-amd64 helm.tar.gz \
  && helm version --client

ADD ./kube-config-generator.sh /usr/local/bin/kube-config-generator

CMD ["sh"]

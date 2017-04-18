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

# Install latest version of helm
RUN set -ex && \
  curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh && \
  chmod 700 get_helm.sh && \
  ./get_helm.sh && \
  && rm -rf get_helm.sh \
  && helm version --client

ADD ./kube-config-generator.sh /usr/local/bin/kube-config-generator

CMD ["sh"]

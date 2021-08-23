FROM python:3.9

LABEL maintainer="Bitkey Inc." \
      org.label-schema.url="https://bitkey.co.jp" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/bitkey-platform/bkp-ci"\
      org.label-schema.vcs-ref=$VCS_REF

# timezone
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# google-cloud-sdk
RUN pip install google-api-python-client google-auth-httplib2 google-auth-oauthlib pandas google-cloud-monitoring==0.34.0 \
    && curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz  \
    && mkdir -p /usr/local/gcloud \
    && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
    && /usr/local/gcloud/google-cloud-sdk/install.sh

ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

# helm
# 既存のスクリプトの動作を考慮し、　helm3 を helm コマンドとして実行可能にする
RUN wget https://get.helm.sh/helm-v3.6.0-linux-amd64.tar.gz && tar xzf helm-v3.6.0-linux-amd64.tar.gz \
  && mv linux-amd64/helm /usr/local/bin/helm \
  && rm -rf linux-amd64

# jq
RUN curl -o /usr/local/bin/jq -L https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 \
    && chmod +x /usr/local/bin/jq

# parallel
RUN apt update && apt install -y parallel

# kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

CMD ["/bin/sh"]

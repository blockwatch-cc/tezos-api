# Build container
#
FROM          idx.trimmer.io/serve:v1.2.3-alpine
MAINTAINER    Alexander Eichhorn <alex@blockwatch.cc>

ARG           BUILD_VERSION
ARG           BUILD_DATE
ARG           BUILD_ID

LABEL         vendor=Blockwatch\ Data\ Inc. \
              io.trimmer.service="tzstats_docs_api" \
              io.trimmer.tier="frontend" \
              io.trimmer.arch="browser" \
              io.trimmer.os="multi" \
              io.trimmer.build-version=$BUILD_VERSION \
              io.trimmer.build-date=$BUILD_DATE \
              io.trimmer.build-id=$BUILD_ID

COPY          ./public/ /var/www/
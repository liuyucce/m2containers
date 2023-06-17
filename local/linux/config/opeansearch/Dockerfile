ARG OPS_VERSION=2.5
FROM opensearchproject/opensearch:${OPS_VERSION}

WORKDIR /usr/share/opensearch

ARG INSTALL_PHONETIC=false

RUN if [ ${INSTALL_PHONETIC} = true ]; then \
    bin/opensearch-plugin install analysis-phonetic \
;fi

ARG INSTALL_ICU=false

RUN if [ ${INSTALL_ICU} = true ]; then \
    bin/opensearch-plugin install analysis-icu \
;fi


EXPOSE 9200 9600

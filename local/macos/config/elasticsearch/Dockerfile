ARG ELK_VERSION=7.5.1
FROM docker.elastic.co/elasticsearch/elasticsearch:${ELK_VERSION}

WORKDIR /usr/share/elasticsearch

ARG INSTALL_PHONETIC=false

RUN if [ ${INSTALL_PHONETIC} = true ]; then \
    bin/elasticsearch-plugin install analysis-phonetic \
;fi

ARG INSTALL_ICU=false

RUN if [ ${INSTALL_ICU} = true ]; then \
    bin/elasticsearch-plugin install analysis-icu \
;fi


EXPOSE 9200 9300

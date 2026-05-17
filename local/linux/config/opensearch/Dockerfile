ARG OPENSEARCH_VERSION=3.0.0
FROM opensearchproject/opensearch:${OPENSEARCH_VERSION}

ARG INSTALL_ANALYSIS_PHONETIC=false
RUN if [ ${INSTALL_ANALYSIS_PHONETIC} = true ]; then \
    bin/opensearch-plugin install --batch analysis-phonetic \
;fi

ARG INSTALL_ANALYSIS_ICU=false
RUN if [ ${INSTALL_ANALYSIS_ICU} = true ]; then \
    bin/opensearch-plugin install --batch analysis-icu \
;fi

EXPOSE 9200 9300

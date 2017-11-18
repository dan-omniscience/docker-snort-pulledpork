#!/bin/bash

# Create the Snort directories:
mkdir -p /etc/snort \
    && mkdir -p /etc/snort/rules \
    && mkdir -p /etc/snort/rules/iplists \
    && mkdir -p /etc/snort/preproc_rules \
    && mkdir -p /etc/snort/so_rules
# Create some files that stores rules and ip lists \
touch /etc/snort/rules/iplists/black_list.rules \
    && touch /etc/snort/rules/iplists/white_list.rules \
    && touch /etc/snort/rules/local.rules \
    && touch /etc/snort/sid-msg.map
# Create our logging directories:
mkdir -p /var/log/snort/archived_logs
# Adjust permissions:
chmod -R 5775 /etc/snort \
    && chmod -R 5775 /var/log/snort \
    && chmod -R 5775 /var/log/snort/archived_logs \
    && chmod -R 5775 /etc/snort/so_rules \
    && chmod -R 5775 /usr/local/lib/snort_dynamicrules
# Change Ownership on folders:
chown -R snort:snort /etc/snort \
    && chown -R snort:snort /var/log/snort \
    && chown -R snort:snort /usr/local/lib/snort_dynamicrules
# Copy the configuration files and the dynamic preprocessors
cd /opt/snort-${SNORT_VERSION}/etc/ \
    && cp *.conf* /etc/snort \
    && cp *.map /etc/snort \
    && cp *.dtd /etc/snort \
    && cd /opt/snort-${SNORT_VERSION}/src/dynamic-preprocessors/build/usr/local/lib/snort_dynamicpreprocessor/ \
    && cp * /usr/local/lib/snort_dynamicpreprocessor/

sed -i "s/include \$RULE\_PATH/#include \$RULE\_PATH/" /etc/snort/snort.conf \
    && sed -i "s/var RULE_PATH \.\.\/rules/var RULE_PATH \/etc\/snort\/rules/" /etc/snort/snort.conf \
    && sed -i "s/var PREPROC_RULE_PATH \.\.\/preproc_rules/var PREPROC_RULE_PATH \/etc\/snort\/preproc_rules/" /etc/snort/snort.conf \
    && sed -i "s/var SO_RULE_PATH \.\.\/so_rules/var SO_RULE_PATH \/etc\/snort\/so_rules/" /etc/snort/snort.conf \
    && sed -i "s/var WHITE_LIST_PATH \.\.\/rules/var WHITE_LIST_PATH \/etc\/snort\/rules\/iplists/" /etc/snort/snort.conf \
    && sed -i "s/var BLACK_LIST_PATH \.\.\/rules/var BLACK_LIST_PATH \/etc\/snort\/rules\/iplists/" /etc/snort/snort.conf \
    && sed -i "s/#include \$RULE_PATH\/local\.rules/include \$RULE_PATH\/local\.rules/" /etc/snort/snort.conf \
    && sed -i '522ioutput unified2: filename snort.u2, limit 128' /etc/snort/snort.conf
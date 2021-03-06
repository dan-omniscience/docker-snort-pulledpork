FROM ubuntu:16.04

MAINTAINER Dan Aharon-Shalom <dan@omniscience.co.il>

RUN apt-get update && \
    apt-get install -y \
    python-setuptools \
    python-pip \
    python-dev \
    wget \
    build-essential \
    bison \
    flex \
    libpcap-dev \
    libpcre3-dev \
    libdumbnet-dev \
    zlib1g-dev \
    iptables-dev \
    libnetfilter-queue1 \
    tcpdump \
    unzip \
    zlib1g-dev \
    liblzma-dev \
    openssl \
    libssl-dev \
    libnghttp2-dev \
    libcrypt-ssleay-perl \
    liblwp-useragent-determined-perl \
    cron \
    vim

ENV DAQ_VERSION 2.0.6
ENV SNORT_VERSION 2.9.11

# Define working directory.
WORKDIR /opt

RUN wget https://www.snort.org/downloads/snort/daq-${DAQ_VERSION}.tar.gz \
    && tar xvfz daq-${DAQ_VERSION}.tar.gz \
    && cd daq-${DAQ_VERSION} \
    && ./configure; make; make install

RUN wget https://www.snort.org/downloads/snort/snort-${SNORT_VERSION}.tar.gz \
    && tar xvfz snort-${SNORT_VERSION}.tar.gz \
    && cd snort-${SNORT_VERSION} \
    && ./configure --enable-sourcefire; make; make install

RUN wget https://github.com/shirkdog/pulledpork/archive/master.tar.gz -O pulledpork-master.tar.gz \
    && tar xzvf pulledpork-master.tar.gz \
    && cd pulledpork-master/ \
    && cp pulledpork.pl /usr/local/bin \
    && chmod +x /usr/local/bin/pulledpork.pl
    
RUN ldconfig

RUN ln -s /usr/local/bin/snort /usr/sbin/snort

# Create the snort user, group & directories:
RUN groupadd snort \
    && useradd snort -r -s /sbin/nologin -c SNORT_IDS -g snort
ADD scripts /opt/scripts

# Create the Snort dynamic rules directory:
RUN mkdir /usr/local/lib/snort_dynamicrules

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    /opt/snort-${SNORT_VERSION}.tar.gz /opt/daq-${DAQ_VERSION}.tar.gz /opt/pulledpork-master.tar.gz

ADD etc/snort /etc/snort
ADD log/snort /var/log/snort

RUN echo "31 03 * * * /usr/local/bin/pulledpork.pl -c /etc/snort/pulledpork.conf -l" >> /var/spool/cron/root

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
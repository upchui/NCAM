FROM debian

RUN apt update -y && apt upgrade -y && apt install \
    libdvbcsa-dev \
    curl \
    build-essential \
    gcc \
    cmake \
    dialog \
    libpcsclite-dev \
    libssl-dev \
    libusb-1.0-0-dev \
    libusb-dev \
    pcsc-tools \
    pcscd \
    git \
    libmbedtls-dev \
    -y

RUN git clone https://github.com/fairbird/NCam.git /usr/local/src/ncam

RUN cd /usr/local/src/ncam && ./config.sh \
    --enable all \
    --disable CARDREADER_DB2COM \
             CARDREADER_INTERNAL \
             CARDREADER_STINGER \
             CARDREADER_STAPI \
             CARDREADER_STAPI5 \
             IPV6SUPPORT \
             LCDSUPPORT \
             LEDSUPPORT \
             READ_SDT_CHARSETS \
             WITH_SIGNING \
    --enable WITH_SSL \
             WITH_NEUTRINO \
             IRDETO_GUESSING \
             WITH_DEBUG \
             WITH_CARDLIST \
             WITH_EMU \
             WITH_SOFTCAM


RUN cd /usr/local/src/ncam && make \
    CONF_DIR=/config \
    DEFAULT_PCSC_FLAGS="-I/usr/include/PCSC" \
    NO_PLUS_TARGET=1 \
    NCAM_BIN=/usr/bin/ncam \
    pcsc-libusb


EXPOSE 8888
VOLUME /config

CMD ["/usr/bin/ncam", "-c", "/config"]
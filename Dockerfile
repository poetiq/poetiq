# Dockerfile for kdb+ CI build agent
# Download the kdb+ Linux (x86) binary from https://kx.com/download to this folder.
#
# To build:
#		docker build -t poetiq/build-agent .
#
# To run:
#		docker run -ti poetiq/build-agent

FROM ubuntu

ENV QHOME=/opt/q \
		QPATH=/opt/q \
		PROJECT_DIR=/root/dev

RUN mkdir -p ${PROJECT_DIR} \
	&& dpkg --add-architecture i386 \
	&& apt-get update \
  && apt-get install -y \
  unzip \
  git \
  wget \
  libc6:i386 \
  libncurses5:i386 \
  libstdc++6:i386 \
  && rm -rf /var/lib/apt/lists/*

WORKDIR $QHOME

ADD ./etc/testq.sh .
ADD ./etc/runci.sh .
ADD linuxx86.zip /tmp

# Install kdb+
RUN wget -P /tmp https://kx.com/347_d0szre-fr8917_llrsT4Yle-5839sdX/3.4/linuxx86.zip \
	&& unzip /tmp/linuxx86.zip -d /opt \
	&& ln -s $QPATH/l32/q /usr/bin/q \
	&& rm /tmp/*

# Install qutil and qspec
RUN git clone https://github.com/nugend/qutil.git qpackages/qutil --depth=1 \
	&& git clone https://github.com/nugend/qspec.git qpackages/qspec --depth=1 \
	&& ln -s $QHOME/qpackages/qutil/lib/bootstrap.q bootstrap.q \
	&& ln -s $QHOME/qpackages/qutil/lib qutil \
	&& ln -s $QHOME/qpackages/qspec/lib qspec \
	&& cat qpackages/qutil/q_q.sample >> q.q \
	&& chmod +x testq.sh \
	&& ln -s $QHOME/testq.sh /usr/bin/testq

WORKDIR ${PROJECT_DIR}
CMD ["bash"]

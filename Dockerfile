# Dockerfile for kdb+ CI build agent
#
# To build:
#		docker build --build-arg KDB_URL=https://kx.com/<YOUR KEY>/<VERSION>/linuxx86.zip -t poetiq/poetiq .
#
# To run:
#		docker run -ti poetiq/poetiq

FROM ubuntu:16.04

ENV QHOME=/opt/q \
		QPATH=/opt/q \
		POETIQ=/poetiq

RUN mkdir -p $POETIQ \
	&& dpkg --add-architecture i386 \
	&& apt-get update \
  && apt-get install -y \
  wget \
  unzip \
  libc6:i386 \
  libncurses5:i386 \
  libstdc++6:i386 \
  && rm -rf /var/lib/apt/lists/*

ARG KDB_URL

# Install kdb+
RUN wget -P /tmp ${KDB_URL} \
	&& unzip /tmp/$(basename ${KDB_URL}) -d $(dirname $QHOME) \
	&& ln -s $QHOME/l32/q /usr/bin/q \
	&& rm /tmp/*

WORKDIR $QHOME

# Install qutil and qspec
RUN wget -O qutil.zip https://github.com/nugend/qutil/archive/master.zip \
	&& wget -O qspec.zip https://github.com/nugend/qspec/archive/master.zip \
	&& unzip '*.zip' \
	&& mkdir qpackages \
	&& mv qutil-master qpackages/qutil \
	&& mv qspec-master qpackages/qspec \
	&& rm *.zip \
	&& ln -s $QHOME/qpackages/qutil/lib/bootstrap.q bootstrap.q \
	&& ln -s $QHOME/qpackages/qutil/lib qutil \
	&& ln -s $QHOME/qpackages/qspec/lib qspec \
	&& cp -f qpackages/qutil/q_q.sample q.q

ADD bin/ci/*.sh /root/

RUN	chmod +x $HOME/testq.sh \
	&& chmod +x $HOME/runci.sh \
	&& ln -s $HOME/testq.sh /usr/bin/testq \
	&& ln -s $HOME/runci.sh /usr/bin/runci

WORKDIR $POETIQ

CMD ["bash"]

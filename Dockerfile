FROM ac1965/arch-mini:latest
MAINTAINER ac1965 <https://github.com/ac1965>

# pacman
COPY mirrorlist /etc/pacman.d/mirrorlist
COPY pacman.conf /etc/pacman.conf
RUN pacman --noconfirm --needed -Syu \
    abs \
    adobe-source-code-pro-fonts \
    adobe-source-sans-pro-fonts \
    base-devel \
    dnsutils \
    emacs \
    gdb \
    go \
    jre7-openjdk jdk7-openjdk \
    man \
    man-pages \
    mercurial \
    ltrace \
    strace \
    tcpdump \
    tor \
    ttf-inconsolata \
    ttf-sazanami \
    python \
    python2 \
    unzip \
    vim \
    xorg \
    yaourt \
    w3m \
    whois \
        > /dev/null
RUN echo -e '\ny\ny\n' | pacman -S multilib-devel && echo -e '\r'

# abs
RUN timeout 5 abs > /dev/null 2>&1 || abs > /dev/null 2>&1

# user
RUN groupadd -r pwner && \
  useradd -r -g pwner -G wheel -d /home/pwner -s /bin/bash -c "Nonroot User" pwner && \
    mkdir /home/pwner

RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER pwner
ENV HOME /home/pwner
ENV USER pwner
WORKDIR /home/pwner/

CMD ["bash"]

FROM nfnty/arch-mini:latest
MAINTAINER ac1965 <https://github.com/ac1965>

# pacman
COPY mirrorlist /etc/pacman.d/mirrorlist
COPY pacman.conf /etc/pacman.conf
RUN pacman --noconfirm --needed -Syu \
    abs \
    base-devel \
    gdb \
    git \
    man \
    man-pages \
    openssh \
    python \
    rsync \
    unzip \
    vim \
    yaourt \
        > /dev/null
RUN echo -e '\ny\ny\n' | pacman -S multilib-devel && echo -e '\r'

# abs
RUN timeout 5 abs > /dev/null 2>&1 || abs > /dev/null 2>&1

# user
RUN useradd -m test
RUN echo "test:test" | chpasswd
RUN echo 'test ALL=(ALL) ALL' >> /etc/sudoers.d/vagrant
USER test
WORKDIR /home/test

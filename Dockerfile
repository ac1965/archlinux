FROM ac1965/arch-mini:latest
MAINTAINER ac1965 <https://github.com/ac1965>

# pacman
COPY mirrorlist /etc/pacman.d/mirrorlist
COPY pacman.conf /etc/pacman.conf
COPY ["packages/", "/tmp/packages/"]
RUN pacman --noconfirm --needed -Syu base-devel linux-grsec linux-grsec-headers
RUN test $(uname -m) == "x86_64" && (echo -e '\ny\ny\n' | pacman -S multilib-devel && echo -e '\r')
RUN pacman --noconfirm --needed -Syu $(egrep -v '^#|^$' /tmp/packages/base.txt)

# user
RUN groupadd -r pwner && \
  useradd -m -r -g pwner -G wheel -d /home/pwner -s /bin/bash -c "Nonroot User" pwner

RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER pwner
ENV HOME /home/pwner
ENV USER pwner
WORKDIR /home/pwner/

CMD ["bash"]

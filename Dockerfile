FROM archlinux/base
MAINTAINER ac1965 <https://github.com/ac1965>

# pacman
COPY ["packages/", "/tmp/packages/"]

RUN echo 'Set disable_coredump false' >> /etc/sudo.conf
RUN echo '[multilib]' >> /etc/pacman.conf && \
    echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf && \
    pacman --noconfirm --needed -Syyu && \
    pacman --noconfirm --needed -S base-devel git go
RUN test $(uname -m) == "x86_64" && (echo -e '\ny\ny\n' | pacman -S multilib-devel && echo -e '\r')

# user
RUN groupadd -r pwner && \
  useradd -m -r -g pwner -G wheel -d /home/pwner -s /bin/bash -c "Nonroot User" pwner && \
  passwd -d pwner && \
  echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
  mkdir -p /home/pwner/.gnupg && \
  echo 'standard-resolver' > /home/pwner/.gnupg/dirmngr.conf && \
  mkdir /build && \
  chown -R pwner:pwner /build && cd /build && \
  sudo -u pwner git clone --depth 1 https://aur.archlinux.org/yay.git && \
  cd yay && \
  sudo -u pwner makepkg --noconfirm -si && \
  sudo -u pwner yay --afterclean --removemake --save && \
  pacman -Qtdq | xargs -r pacman --noconfirm -Rcns && \
  rm -fr /home/pwner/.cache /build

USER pwner
WORKDIR /home/pwner/
RUN yay --noconfirm --needed -S $(egrep -v '^#|^$' /tmp/packages/base.txt) && yay --noconfirm -Scc
RUN git config --global pull.rebase false
RUN git clone --depth=1 https://github.com/radareorg/radare2 && \
  cd radare2 && ./sys/install.sh && \
  r2pm init && \
  for repo in r2dec r2ghidra-dec; do r2pm -i ${repo}; done
RUN sudo pip install git+https://github.com/Gallopsled/pwntools.git
RUN git clone https://github.com/longld/peda.git ~/peda && echo "source ~/peda/peda.py" >> ~/.gdbinit

CMD ["bash"]

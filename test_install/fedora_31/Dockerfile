FROM fedora:31
RUN dnf install -y git vim make sudo sed
RUN sed -i s'/%wheel	ALL=(ALL)	ALL/#%wheel ALL=(ALL)   ALL/g' /etc/sudoers
RUN sed -i s'/# %wheel	ALL=(ALL)	NOPASSWD: ALL/%wheel    ALL=(ALL)   NOPASSWD: ALL/g' /etc/sudoers
RUN useradd -m -G wheel uggla
USER uggla
WORKDIR /home/uggla
COPY RSTCACHE /dev/null
RUN git clone --recurse-submodules https://github.com/uggla/dotfiles.git

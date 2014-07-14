FROM stoo/erlang:17.1-1

# Install additional packages
RUN apt-get install -y build-essential
RUN apt-get install -y libwxgtk2.8
RUN apt-get install -y openjdk-6-jdk
RUN apt-get install -y autoconf
RUN apt-get install -y python
RUN apt-get install -y python-virtualenv
RUN apt-get install -y git
RUN apt-get install -y strace
RUN apt-get install -y vim

# Install repo
RUN curl https://storage.googleapis.com/git-repo-downloads/repo \
        >/usr/local/bin/repo
RUN chmod +x /usr/local/bin/repo

# Create a devdock user and switch to it
RUN useradd -c "Devdock User" -d /devdock -u 10000 -m -U devdock
WORKDIR /devdock

# Copy in SSH key
ENV GIT_SSH /devdock/sshwrap
ADD sshid /devdock/sshid
ADD sshwrap /devdock/sshwrap
ADD dotssh.tar /devdock/
RUN chown devdock:devdock sshid sshwrap
RUN chmod 0600 sshid

USER devdock
ENV HOME /devdock

# Populate standard Erlang libs
ENV ERL_LIBS /devdock/erl-libs
RUN mkdir -p erl-libs
WORKDIR erl-libs
RUN repo init -u https://github.com/timclassic/erl-libs
RUN repo sync

RUN make -sf build/apps.mk

# Create some directories and add local bin/ directory to PATH
WORKDIR /devdock
RUN mkdir work
RUN mkdir bin
RUN ln -s ../erl-libs/relx/relx bin/relx
RUN ln -s ../erl-libs/rebar/rebar bin/rebar
ENV PATH $PATH:/devdock/bin

# Set starting working directory
WORKDIR work

CMD ["/bin/bash"]

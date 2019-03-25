FROM centos:latest
MAINTAINER info@nebulousllc.net
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]

# Make sure the package repo is up to date
RUN yum update -y

RUN yum install -y \
    curl \
    git \
    curl \
    nano \
    epel-release \
    wget \
    nfs-utils \
    bind-utils \
    python \
    ntp \
    unzip \
    openssh-server \
    openssh-clients \
    sudo \
    passwd \
    initscripts \
    tree

RUN yum install -y \
	htop

RUN yum clean all

RUN source ~/.bash_profile

# start sshd to generate host keys, patch sshd_config and enable yum repos
RUN (/usr/sbin/sshd; \
     sed -i 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config; \
     sed -i 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config; \
     sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config; \
     sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/CentOS-Base.repo)

RUN (mkdir -p /root/.ssh/; \
     echo "StrictHostKeyChecking=no" > /root/.ssh/config; \
     echo "UserKnownHostsFile=/dev/null" >> /root/.ssh/config)

RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
RUN ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519

# passwords 
RUN echo "root:password" | chpasswd

#WORKDIR /tmp/workdir

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
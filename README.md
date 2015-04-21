# ev3rt-build
===============

# �͂��߂�
docker�ɂ�EV3RT(arm�p�r���h��)�r���h����񋟂���R���e�i�ł��B  
sshd�����Ă���A�R���e�i�N�����ɐݒ肵��1���[�U�Ń��O�C���ł��܂��B  
�R���e�i��port���Ԃ���Ȃ�����A�C�ӂ̐��N���ł��܂��B  
jenkins-slave�Ƃ��Ă̗��p��z�肵�Ajava��sshd���C���X�g�[���ς݂ł��B

�܂��A�R���e�i���̃t�@�C���̓z�X�g������͊u������܂��B�i���I�ȃt�@�C���̕ۑ����K�v�ȏꍇ��-v�I�v�V�������g�p���ăz�X�g���̃f�B���N�g�����}�E���g���Ă��������B

�g����
------
# Installation
�ȉ��̂悤��docker image��pull���܂��B

    docker pull sharaku/ev3rt-build

Docker image�������ō\�z���邱�Ƃ��ł��܂��B

    https://github.com/sharaku/docker-ev3rt-build.git
    cd docker-ev3rt-build
    docker build --tag="$USER/ev3rt-build" .

# Quick Start
ev3rt-build��image�����s���܂��B

    docker run -d -e "LOGIN_USER=login_user:login_user_passwd" -p 10022:22 sharaku/ev3rt-build

sshd�̑����/bin/bash�ŋN�����邱�Ƃ��ł��܂��B
���̏ꍇ�Aroot���[�U�ł̃��O�C���ƂȂ�܂��B

    docker run -it sharaku/ev3rt-build /bin/bash

## Argument

+   `-v /path/to/data:/path/to/container/data:rw` :  
    �i���I�ɕۑ�����f�[�^�̃f�B���N�g�����w�肵�܂��B�C�ӂ̐���-v�I�v�V�������g�p�\�ł��B

+   `-e "LOGIN_USER=login_user:login_user_passwd"` :  
    ���O�C�����郆�[�U���A�p�X���[�h��":"�ŋ�؂��Ďw�肵�܂��B  
    ��F-e "LOGIN_USER=hogehoge:hogehoge-passwd"

+   -p port:22 :  
    �O�����J����|�[�g��ݒ肵�܂��B

# Installed environment
ev3rt-build�R���e�i�ɂ͈ȉ����C���X�g�[���ς݂ł��B

base:debian 7.6

servers:

    sshd

build tools:

    build-essential, cppcheck
    gcc-arm-none-eabi=4.9.3.2015q1-0trusty13, u-boot-tools, libboost1.55-all-dev

tools:

    wget, git, vim, bzip2, nkf, unzip, bc, default-jdk, qemu

���p��
------

# ev3rt-build
�X�^���_�[�h��ev3rt-build�Ƃ��Ďg�p����ɂ͈ȉ��̂悤�ɂ��܂��B

�ȉ��̏�����ev3rt-build���\�z�����ł��B

+ docker����z�X�g��IP�F192.168.0.2
+ ���[�U���Fhogehoge
+ �p�X���[�h�Fhogehoge-passwd
+ �|�[�g�F10022
+ �{�����[���i�z�X�g���j�F/var/lib/build-volume
+ �{�����[���i�R���e�i���j�F/var/lib/volume

�@

    mkdir /var/lib/build-volume

    docker run -d \
      -v /var/lib/build-volume:/var/lib/volume:rw \
      -e "LOGIN_USER=hogehoge:hogehoge-passwd" \
      -p 10022:22 sharaku/ev3rt-build


# jenkins-slave
jenkins-slave�Ƃ��Ďg�p����ɂ͈ȉ��̂悤�ɂ��܂��B

+ ���[�U���Fjenkins
+ �p�X���[�h�Fjenkins###
+ jenkins�|�[�g�F8080
+ �|�[�g(�������p)�F10022
+ �{�����[���i�z�X�g���j�F/var/lib/jenkins-volume
+ �{�����[���i�R���e�i���j�F/var/lib/jenkins

�菇

1.�r���h���̕ۑ��̈���쐬���܂�  

      mkdir /var/lib/jenkins-volume

2.sharaku/ev3rt-build�R���e�i���N�����܂��B  

      docker run -d \
        -v /var/lib/jenkins-volume:/var/lib/jenkins:rw \
        -e "LOGIN_USER=jenkins:jenkins###" \
        -p 10022:22 sharaku/ev3rt-build

3.jenkins���N�����A�ݒ���s���܂��B  

      docker run -d -p 8080:8080 jenkins

4.�u���E�U����Ajenkins�֐ڑ����܂��B  
5.jenkins�̃��j���[���� `Jenkins�̊Ǘ� -> �m�[�h�̊Ǘ� -> �V�K�m�[�h�쐬` ���J���܂��B  
6. `�m�[�h��` ����͌�A`�_���X���[�u` �Ƀ`�F�b�N�����A`OK`�������܂��B  
7.`�����[�gFS���[�g`��"/var/lib/jenkins"����͂��܂��B  
8.`�N�����@`��"ssh�o�R�Ł`"��I�����܂��B  
9.`�z�X�g`�̓z�X�g��IP�������́A�h���C�����w�肵�܂��B  
10.`�F�؏��`��`add`�������A���[�U���ƃp�X���[�h��ݒ肵�܂��B  
11.`���x�Ȑݒ�`�������A`�|�[�g`�̗���10022���w�肵�܂��B  
12.`�ۑ�`�������܂��B

�ȏ�Őڑ����ł���悤�ɂȂ�܂��B

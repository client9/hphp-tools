#!/bin/bash
set -e


echo "Installing baseline..."

# current directory
CURDIR=`pwd`

#
# All of thee are stock 5.6 stuff
#

if [ 1 -eq 1 ]; then
sudo yum -y install git wget patch \
    flex bison \
    pcre-devel.x86_64 \
    re2c.x86_64 \
    gd.x86_64 gd-devel.x86_64 \
    zlib.x86_64 zlib-devel.x86_64 \
    libxml2.x86_64 libxml2-devel.x86_64 \
    libcap.x86_64 libcap-devel.x86_64 \
    binutils.x86_64 binutils-devel.x86_64 \
    expat.x86_64 expat-devel.x86_64 \
    gcc.x86_64 gcc-c++.x86_64 \
    gcc44.x86_64 gcc44-c++.x86_64 libstdc++44-devel.x86_64 \
    bzip2.x86_64 bzip2-libs.x86_64 bzip2-devel.x86_64 \
    openldap-devel.x86_64 \
    readline.x86_64 readline-devel.x86_64 \
    ncurses.x86_64 ncurses-devel.x86_64 \
    tbb tbb-devel

echo "Installing libmcrypt stuff..."
# no idea
sudo yum -y --disablerepo='*' --enablerepo='CentOS-5.6-extras' install  \
    libmcrypt.x86_64 libmcrypt-devel.x86_64

echo "Installing Etsy mysql devel bits..."
# etsy special stuff
sudo yum -y install Percona-Server-devel-51
fi

export CC=/usr/bin/gcc44
export CXX=/usr/bin/g++44


export HPHP_ROOT=/usr/local/hphp-root
export HPHP_SRC=/usr/local/hphp-src
export HPHP_TAR=/usr/local/hphp-tar
export HPHP_BIN=${HPHP_ROOT}/bin
export PATH=${HPHP_BIN}:$PATH
export CPP_FLAGS=-I${HPHP_ROOT}/include
export LD_LIBRARY_PATH=${HPHP_ROOT}/lib

#
# Stuff needed by hphp
#
export CMAKE_PREFIX_PATH=${HPHP_ROOT}
export HPHP_HOME=${HPHP_SRC}/hiphop-php
export HPHP_LIB=${HPHP_HOME}/bin


if [ ! -d ${HPHP_ROOT} ]; then
mkdir -p ${HPHP_ROOT}
chmod a+rwx ${HPHP_ROOT}
fi

if [ ! -d ${HPHP_SRC} ]; then
mkdir -p ${HPHP_SRC}
chmod a+rwx ${HPHP_SRC}
fi

if [ ! -d ${HPHP_TAR} ]; then
mkdir -p ${HPHP_TAR}
chmod a+rwx ${HPHP_TAR}
fi

if [ ! -d ${HPHP_BIN} ]; then
mkdir -p ${HPHP_BIN}
chmod a+rwx ${HPHP_BIN}
fi
sudo ln -sf /usr/bin/gcc44 ${HPHP_BIN}/gcc
sudo ln -sf /usr/bin/g++44 ${HPHP_BIN}/g++

gcc --version
g++ --version

cd ${HPHP_ROOT}

cd ${HPHP_SRC}
if [ -d hiphop-php ]; then
    cd hiphop-php
    git pull http://github.com/facebook/hiphop-php.git
else
    git clone http://github.com/facebook/hiphop-php.git
    cd hiphop-php
fi

cd ${HPHP_TAR}
if [ ! -f curl-7.21.2.tar.gz ]; then
    wget http://curl.haxx.se/download/curl-7.21.2.tar.gz
fi
cd ${HPHP_SRC}
if [ ! -d curl-7.21.2 ]; then
    tar -xvzf ${HPHP_TAR}/curl-7.21.2.tar.gz
    cd curl-7.21.2
    cp ../hiphop-php/src/third_party/libcurl.fb-changes.diff .
    patch -p1 < libcurl.fb-changes.diff
    ./configure --prefix=${HPHP_ROOT} --enable-static
    make
    make install
fi
cd ${HPHP_TAR}
if [ ! -f imap-2007f.tar.gz ]; then
   wget ftp://ftp.cac.washington.edu/imap/imap-2007f.tar.gz
fi
cd ${HPHP_SRC}
if [ ! -d imap-2007f ]; then
    tar -xzvf ${HPHP_TAR}/imap-2007f.tar.gz
    cd imap-2007f
    make slx SSLTYPE=none
    cp -f ./c-client/c-client.a ${HPHP_ROOT}/lib/libc-client.a
    cp -r ./c-client ${HPHP_ROOT}/include
fi



cd ${HPHP_TAR}
if [ ! -f cmake-2.8.5.tar.gz ]; then
    wget http://www.cmake.org/files/v2.8/cmake-2.8.5.tar.gz
fi
cd ${HPHP_SRC}
if [ ! -d cmake-2.8.5 ]; then
    tar -xzvf ${HPHP_TAR}/cmake-2.8.5.tar.gz
    cd  cmake-2.8.5
    ./bootstrap --prefix=${HPHP_ROOT}
    make
    make install
fi

cd ${HPHP_TAR}
if [ ! -f icu4c-4_8_1-src.tgz ]; then
   wget http://download.icu-project.org/files/icu4c/4.8.1/icu4c-4_8_1-src.tgz
fi
cd ${HPHP_SRC}
if [ ! -d icu ]; then
    tar -xzf ${HPHP_TAR}/icu4c-4_8_1-src.tgz
    cd icu/source
    # MUST MAKE SHARED.. static don't work
    ./configure --prefix=${HPHP_ROOT} --disable-static
    make
    make install
fi

cd ${HPHP_TAR}
if [ ! -f onig-5.9.2.tar.gz ]; then
   wget http://www.geocities.jp/kosako3/oniguruma/archive/onig-5.9.2.tar.gz
fi
cd ${HPHP_SRC}
if [ ! -d onig-5.9.2 ]; then
   tar -xzf ${HPHP_TAR}/onig-5.9.2.tar.gz
   cd onig-5.9.2
   # static works ok
   ./configure --prefix=${HPHP_ROOT} --enable-static --disable-shared
   make
   make install
fi


cd ${HPHP_TAR}
if [ ! -f libevent-1.4.14b-stable.tar.gz ]; then
   wget http://www.monkey.org/~provos/libevent-1.4.14b-stable.tar.gz
fi
cd ${HPHP_SRC}
if [ ! -d libevent-1.4.14b-stable ]; then
   tar -xzf ${HPHP_TAR}/libevent-1.4.14b-stable.tar.gz
   cd libevent-1.4.14b-stable
   cp ../hiphop-php/src/third_party/libevent-1.4.14.fb-changes.diff .
   patch -p1 < libevent-1.4.14.fb-changes.diff
   ./configure --prefix=${HPHP_ROOT} --enable-static
   make
   make install
fi

cd ${HPHP_TAR}
if [ ! -f libmemcached-0.49.tar.gz ]; then
    wget http://launchpad.net/libmemcached/1.0/0.49/+download/libmemcached-0.49.tar.gz
fi
cd ${HPHP_SRC}
if [ ! -d libmemcached-0.49 ]; then
    tar -xzf ${HPHP_TAR}/libmemcached-0.49.tar.gz
    cd libmemcached-0.49
    ./configure --prefix=${HPHP_ROOT} --enable-static
    make
    make install
fi

cd ${HPHP_TAR}
if [ ! -f boost_1_48_0.tar.bz2 ]; then
   wget http://sourceforge.net/projects/boost/files/boost/1.48.0/boost_1_48_0.tar.bz2/download
fi
cd ${HPHP_SRC}
if [ ! -d boost_1_48_0 ]; then
    echo "Untarring boost...."
    tar -xjf ${HPHP_TAR}/boost_1_48_0.tar.bz2
    echo "Boot strapping boost...."
    cd boost_1_48_0
    ./bootstrap.sh --prefix=${HPHP_ROOT} --libdir=${HPHP_ROOT}/lib
    echo "Building boost...."
    ./b2 --layout=system --without-mpi --without-python link=static install
fi

export BOOST_LIBRARYDIR=${HPHP_ROOT}/include/boost

echo "COMPILING HIPHOP"

cd ${HPHP_SRC}
cd hiphop-php
git submodule init
git submodule update
rm -f CMakeCache.txt
${HPHP_ROOT}/bin/cmake .
make clean
make
make install

cp -f ./src/hphp/hphp ${HPHP_ROOT}/bin
cp -f ./bin/gen_constants.php ${HPHP_ROOT}/bin
cp -fr src/system ${HPHP_ROOT}

sudo rpmbuild -bb ${CURDIR}/hiphop-bin.spec


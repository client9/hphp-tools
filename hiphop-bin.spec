Name:          hphp
Version:       20120503
Release:        1%{?dist}
Summary:        Partial build of HpHp for use in static analysis.

Group:          xxx
License:        none
URL:            https://github.com/facebook/hiphop-php

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildRequires: wget patch flex bison pcre-devel
BuildRequires: re2c
BuildRequires: gd gd-devel
BuildRequires: zlib zlib-devel
BuildRequires: libxml2 libxml2-devel
BuildRequires: libcap libcap-devel
BuildRequires: binutils binutils-devel
BuildRequires: expat expat-devel
BuildRequires: gcc gcc-c++
BuildRequires: gcc44 gcc44-c++ libstdc++44-devel
BuildRequires: bzip2 bzip2-libs bzip2-devel
BuildRequires: openldap-devel
BuildRequires: readline readline-devel
BuildRequires: ncurses ncurses-devel
BuildRequires: tbb tbb-devel
BuildRequires: libmcrypt libmcrypt-devel

Requires:      tbb
Requires:      libmcrypt
Requires:      readline
Requires:      ncurses
Requires:      gd
Requires:      libxml2

%description
HpHp for static analysis only.  Probably won't work for full compilation.

%prep

%build

%install

rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/usr/local/hphp-root
mkdir -p $RPM_BUILD_ROOT/usr/local/hphp-root/lib
mkdir -p $RPM_BUILD_ROOT/usr/local/hphp-root/bin
mkdir -p $RPM_BUILD_ROOT/usr/local/hphp-root/system


HPHP_ROOT=/usr/local/hphp-root
HPHP_SRC=/home/ngalbreath/hphp-src

#cp -r /home/ngalbreath/hphp-root $RPM_BUILD_ROOT/usr/local/hphp-root
cp ${HPHP_ROOT}/lib/libcurl.so.4 $RPM_BUILD_ROOT/usr/local/hphp-root/lib
cp ${HPHP_ROOT}/lib/libevent-1.4.so.2 $RPM_BUILD_ROOT/usr/local/hphp-root/lib
cp ${HPHP_ROOT}/lib/libicudata.so.48 $RPM_BUILD_ROOT/usr/local/hphp-root/lib
cp ${HPHP_ROOT}/lib/libicui18n.so.48 $RPM_BUILD_ROOT/usr/local/hphp-root/lib
cp ${HPHP_ROOT}/lib/libicuuc.so.48 $RPM_BUILD_ROOT/usr/local/hphp-root/lib
cp ${HPHP_ROOT}/lib/libmemcached.so.7 $RPM_BUILD_ROOT/usr/local/hphp-root/lib
cp ${HPHP_ROOT}/bin/gen_constants.php $RPM_BUILD_ROOT/usr/local/hphp-root/bin
cp ${HPHP_ROOT}/bin/hphp $RPM_BUILD_ROOT/usr/local/hphp-root/bin
cp -r ${HPHP_SRC}/hiphop-php/src/system/ $RPM_BUILD_ROOT/usr/local/hphp-root

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
/usr/local/hphp-root/lib/*
/usr/local/hphp-root/bin/*
/usr/local/hphp-root/system/*

%doc


%changelog

hphp-tools
==========

Tools to aid in building or using HpHp

Hi

here's what you do

Edit hiphop-bin.spec and change the

 Version:       20120503

to the current date

Edit hiphop-bin.spec and change

HPHP_SRC=/home/ngalbreath/hphp-src

to you.


cd to this directory (you probably are already).

Then do:

./hiphop-centos.sh

This will take a while to run.  At one point the imap driver askes you
to type "y" or "yes" (do it).  After another hour it will be done.

your new RPM is

/usr/src/redhat/RPMS/x86_64/hphp-DATE-1.x86_64.rpm

tada!

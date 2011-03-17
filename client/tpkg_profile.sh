#!/bin/bash

tpkgbase="/opt/tpkg"

if [ -f /etc/tpkg.conf ]
then
  base=`cat /etc/tpkg.conf | grep '^base\s*=' | awk -F= '{print $2}' | sed 's/^\s*//' | sed 's/\s*$//'`
  if [ "$base" != "" ]
  then
    tpkgbase=$base
  fi
fi

if [ -f $HOME/.tpkg.conf ]
then
  base=`cat $HOME/.tpkg.conf | grep '^base\s*=' | awk -F= '{print $2}' | sed 's/^\s*//' | sed 's/\s*$//'`
  if [ "$base" != "" ]
  then
    tpkgbase=$base
  fi
fi

PATH=$tpkgbase/bin:$PATH
export PATH
if [ -n "$MANPATH" ]
then
  MANPATH=$tpkgbase/man:$MANPATH
else
  MANPATH=$tpkgbase/man
fi
export MANPATH

for i in $tpkgbase/etc/profile.d/*.sh ; do
    if [ -r "$i" ]; then
        . $i
    fi
done

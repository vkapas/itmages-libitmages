#!/bin/bash -x

VER="$1"
MAXLEN=2

if [ -z "${VER}" ] ; then

    VER=`cat .bzr/branch/last-revision | awk '{print $1}'`
    len=`expr length $VER`
    
    if [ -n "${VER}" ] && [ $len -ge $MAXLEN ] ; then
        start=0
        let "start=$len - $MAXLEN"
        SVER="${VER:$start:$len}"
        let "SVER+=1"
        VER="${VER:0:-${MAXLEN}}.${SVER}"

    else
        if [ -n "${VER}" ] && [ `expr length $VER` -lt $MAXLEN ] ; then
            let "VER+=1"
            VER="0.$VER"
        fi
    fi
fi

sed  -i "s/\((.*)\)/($VER)/" "debian/changelog"
echo $VER > ./VERSION


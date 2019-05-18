#!/bin/sh
OS=`uname`

BIN_TOP=/bin/top
if [ -x ${BIN_TOP} ]; then
        echo "CPU Usage:"
        ${BIN_TOP} -b -n 1
fi

BIN_PS=/bin/ps
if [ -x ${BIN_PS} ]; then
        echo "Top Memory Usage:"
        ${BIN_PS} aux | sort -r -nk 4 | head
fi

VMSTAT=/usr/bin/vmstat
if [ -x ${VMSTAT} ]; then
        echo ""
        echo "Virtual Memory Info:"

        if [ "${OS}" = "FreeBSD" ]; then
                ${VMSTAT} 1 3
        else
                HAS_TIMESTAMP=`${VMSTAT} --help 2>&1 | grep -c '\-t'`

                if [ "${HAS_TIMESTAMP}" = "0" ]; then
                        date
                        ${VMSTAT} -w 1 3
                        date
                else
                        ${VMSTAT} -tw 1 3
                fi
        fi
fi

NETSTAT=/usr/bin/netstat
if [ -x ${NETSTAT} ]; then
        echo ""
        echo "Network Info:"

        ${NETSTAT} -anlp
fi

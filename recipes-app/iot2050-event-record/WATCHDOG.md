Due to the fact that the watchdog is non-stoppable, getting a watchdog
event always requires opening the watchdog and feeding the watchdog. So
the watchdog event could not be included into the `iot2050-event-record`
service.

This README file explains how to get the watchdog reset status and how to
inject it into `iot2050-event-record` service.

# How to get the watchdog reset status?

The `wdt_example.py` below shows how to get the watchdog reset status.

```py
import array
import fcntl
import os
import psutil
import time
from datetime import datetime

# Implement _IOR function for wdt kernel ioctl function
_IOC_NRBITS   =  8
_IOC_TYPEBITS =  8
_IOC_SIZEBITS = 14
_IOC_DIRBITS  =  2

_IOC_NRSHIFT = 0
_IOC_TYPESHIFT =(_IOC_NRSHIFT+_IOC_NRBITS)
_IOC_SIZESHIFT =(_IOC_TYPESHIFT+_IOC_TYPEBITS)
_IOC_DIRSHIFT  =(_IOC_SIZESHIFT+_IOC_SIZEBITS)

_IOC_NONE = 0
_IOC_WRITE = 1
_IOC_READ = 2
def _IOC(direction,type,nr,size):
    return (((direction)  << _IOC_DIRSHIFT) |
        ((type) << _IOC_TYPESHIFT) |
        ((nr)   << _IOC_NRSHIFT) |
        ((size) << _IOC_SIZESHIFT))
def _IOR(type, number, size):
    return _IOC(_IOC_READ, type, number, size)

WDIOC_GETBOOTSTATUS = _IOR(ord('W'), 2, 4)
WDIOF_CARDRESET = 0x20
WDT_PATH = "/dev/watchdog"

EVENT_STRINGS = {
    "wdt": "{} watchdog reset is detected",
    "no-wdt": "{} watchdog reset isn't detected"
}

def feeding_the_watchdog(fd):
    while True:
       ret = os.write(fd, b'watchdog')
       print("Feeding the watchdog ...")
       # Let's say the watchdog timeout is more than 30 s
       time.sleep(30)

def record_wdt_events():
    status = array.array('h', [0])
    fd = os.open(WDT_PATH, os.O_RDWR)
    if fcntl.ioctl(fd, WDIOC_GETBOOTSTATUS, status, 1) < 0:
        print("Failed to get wdt boot status!")

    boot_time = datetime.fromtimestamp(psutil.boot_time())
    if (WDIOF_CARDRESET & status[0]):
        print(EVENT_STRINGS["wdt"].format(boot_time))
    else:
        print(EVENT_STRINGS["no-wdt"].format(boot_time))

    feeding_the_watchdog(fd)

    os.close(fd)

if __name__ == "__main__":
    record_wdt_events()
```

# How to inject it into iot2050-event-record?

Please refer to [README.md](./README.md).

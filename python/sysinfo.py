from yattac import doc
import os
import netifaces


class GetInfo(object):

    def system_info(self):
        self.sysinfo = {}
        self.sysinfo['name'] = platform.uname()[1]
        self.sysinfo['os'] =  platform.uname()[0]
        self.sysinfo['os_version'] =  platform.uname()[2]
        self.sysinfo['processor'] = platform.uname()[4]

        return self.sysinfo

    def networking_info(self):
        self.netinfo = {}
        # List of interfaces
        self.netinfo['interfaces'] = netifaces.interfaces()
        # Get ip addresses
        self.ips = []
        for self.iface in self.networking['interfaces']:
             self.ip = netifaces.ifaddresses(self.iface)
             if self.ip:
                 self.ips.add(self.iface + " " + self.ip)
        self.netinfo['ips'] = self.ips

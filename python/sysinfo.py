from yattac import doc
import os
import netifaces
import getpass


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
        # Get ip addresses of interfaces
        self.ips = []
        for self.iface in self.networking['interfaces']:
             self.ip = netifaces.ifaddresses(self.iface)
             if self.ip:
                 try:
                     self.ips.add(self.iface + " " + self.ip)[2][0]['addr']
                 except Exception as e:
                     raise e
        self.netinfo['ips'] = self.ips
        
        return self.netinfo
        
        
        def user_info(self):
            # Get username
            self.userinfo = {}
            self.userinfo['name'] = getpass.getuser()
            # Get homedir
            if os.name == 'posix':
                self.userinfo['homedir'] = os.environ['HOME']
            elif os.name == 'nt':
                self.userinfo['homedir'] = os.environ['USERPROFILE']
       return self.userinfo
                
            
            
        

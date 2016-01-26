#!/usr/bin/env python2
# -*- coding: utf-8 -*-
#
"""
Copyright (c) 2015 mtask @github.com



Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:



The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.



THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
"""

"""
Usage:

Geoping is pinging tool that lets you ping hosts and draw map of pinged hosts. Hosts that were up are shown as green plots on map and hosts that were down as red plots. It uses os's ping command so depending on your system it may not need root access.
External depencies: Matplotlib, Basemap, pygeoip
Run: $ python geoping.py
Geoping has own command prompt. Commands are "ping", "draw", "help", "exit".
You can ping one or multiple hosts at same time, ping example:
GeoPing> ping example.com example2.com
With "draw" command it popups the map of pinged hosts.
"""

import sys, os, pygeoip, subprocess, urllib2, gzip
from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
import numpy as np
 
 
         
class maintain(object):
    #Tries to download Maxmind's db if doesn't exist in current directory
    def maxmind_dload(self):
        print "Downloading database.."
        try:
            self.gz_file = "GeoLiteCity.dat.gz"
            self.url = "http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz"
            self.res = urllib2.urlopen(self.url)
            self.fh = open(self.gz_file, "w")
            self.fh.write(self.res.read())
            self.fh.close()
            self.dat_file = gzip.open(self.gz_file, 'rb')
            self.content = self.dat_file.read()
            self.dat_file.close()
            self.outF = file("GeoLiteCity.dat", 'wb')
            self.outF.write(self.content)
            self.outF.close()
        except Exception as e:
            print "[!] Error downloading/updating database, try manually from http://dev.maxmind.com/geoip/legacy/geolite/"
            raw_input("Press Enter to show error message")
            raise e
 
class draw_map(object):
    #Get host's longitude and latitude
    def location(self, destination):
        self.dest = destination
        self.rawdata = pygeoip.GeoIP('GeoLiteCity.dat')
        try:
            self.data = self.rawdata.record_by_addr(self.dest)
        except:
            self.data = self.rawdata.record_by_name(self.dest)
                
        self.longi = self.data['longitude']
        self.lat = self.data['latitude']
        
        return self.lat, self.longi
    
    #Draw hosts as plot on world map, red plot if host down, green if up
    def drawMap(self, longitudes, latitudes, statuses, hosts):
        self.mymap = Basemap(projection='robin', resolution = 'l',
            area_thresh = 1000.0, lat_0=0, lon_0=-100)
 
        self.mymap.drawcoastlines()
        self.mymap.drawcountries()
        self.mymap.fillcontinents(color='gray')
        self.mymap.drawmapboundary()
        self.mymap.drawmeridians(np.arange(0, 360, 30))
        self.mymap.drawparallels(np.arange(-90, 90, 30))
        for self.lon,self.lat, self.stat, self.host in zip(longitudes, latitudes, statuses, hosts):
            if self.stat.strip() == '1':
                self.c = 'go'
            else:
                self.c = 'ro'
            self.x,self.y = self.mymap(self.lon, self.lat)
            self.mymap.plot(self.x, self.y, self.c, markersize=10)
            plt.text(self.x,self.y,self.host,fontsize=12,fontweight='bold',
                    ha='center',va='top',color='b')
        self.fig = plt.gcf()
        self.fig.canvas.set_window_title('GeoPing')
        plt.title("Results")
        plt.show()
        
    #Note: Test windows ping   
    def ping(self, targ):
        self.t = targ
        if os.name == 'posix':
            self.output = subprocess.check_output("ping -w 1 -c 1 "+self.t+" | grep icmp* | wc -l" , shell=True)
            #output is 0 or 1
                  
        else:
            self.output_raw = subprocess.check_output("ping -n 1 " +self.t)
            if "Received = 1" in self.output_raw:
                self.output = "1"
            else:
                self.output = "0"
        
        return self.output
     
    #command prompt for GeoPing  
    def main(self):
        self.latudes = []
        self.lotudes = []
        self.statuses = []
        self.hosts = []
        
        while True:
            self.cmd = raw_input("GeoPing>")
            if self.cmd.lower() == "exit":
                print "Exiting.."
                sys.exit(0)
            elif self.cmd.lower() == "help":
                print "|Command|Explanation" 
                print "Help - print this page"
                print "Exit - Exit from GeoPing"
                print "ping <destination(s)> - ping ip/domain"
                print "draw - draw and display map from your pings"
                
            elif "ping" in self.cmd:
                self.destinations = self.cmd.split()
                self.count = 0
                for self.dest in self.destinations:
                    if self.count != 0:
                        self.la, self.lo = self.location(self.dest)
                        self.status = self.ping(self.dest)
                        self.latudes.append(self.la)
                        self.lotudes.append(self.lo)
                        self.statuses.append(self.status)
                        self.hosts.append(self.dest)
                        
                    self.count += 1
            
            elif self.cmd.lower() == "draw":
                self.drawMap(self.lotudes, self.latudes, self.statuses, self.hosts)
            else:
                print "Unkown command"
        
 
if __name__ == '__main__':
    mtain = maintain()
    dm = draw_map()
    if not os.path.isfile('GeoLiteCity.dat'):
        mtain.maxmind_dload()
    dm.main()
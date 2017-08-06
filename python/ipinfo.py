from bs4 import BeautifulSoup
import sys
import re
import argparse
import os
import urllib2
import gzip
import pygeoip
import pip

class IpLocations(object):

    def __init__(self):
        if not os.path.isfile('GeoLiteCity.dat'):
            self.maxmind_dload()
            
    def get_ip_location_obj(self,ip):
        self.ip = ip
        self.rawdata = pygeoip.GeoIP('GeoLiteCity.dat')
        try:
            self.data = self.rawdata.record_by_addr(self.ip)
        except Exception as e:
            er = e
            try:
               self.data = self.rawdata.record_by_name(self.ip)
            except:
                raise er
        if not self.data:
            print "Couldn't find any info for that address"
            sys.exit(1)
            
        return self.data

    def maxmind_dload(self):
        self.yn = raw_input("Download geo database (y/N)")
        if self.yn.lower() != 'y':
            sys.exit(1)
        print "[!] Downloading..."
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
            os.remove('GeoLiteCity.dat.gz')
        except Exception as e:
            print "[!] Error downloading/updating database, try manually from http://dev.maxmind.com/geoip/legacy/geolite/"
            raw_input("Press Enter to show error message")
            raise e

class CountryIps(object):

    def get_countries(self):
    
        self.ccodes = []
        self.r = urllib2.urlopen('http://ipdeny.com/ipblocks/').read()
        self.soup = BeautifulSoup(self.r,"html.parser")
        self.elements = self.soup.find_all('table')[2].find_all("tr")
        for e in self.elements:
            self.res_raw = e.select('td p')[0].getText()
            self.rcc = re.compile('\((.*?)\)')
            self.mcc = self.rcc.search(self.res_raw)
            if self.mcc:
                # Country Code
                self.cc = self.mcc.group(1)
            self.country = self.res_raw.split(" (")[0]
            self.ccodes.append((self.country,self.cc))
        return self.ccodes

    def get_ips(self, country):
        self.country = country
        self.ip_list =  urllib2.urlopen('http://ipdeny.com/ipblocks/data/countries/'+self.country+'.zone').readlines()
        self.ip_list = map(lambda s: s.strip(), self.ip_list)
        return self.ip_list


def parse_args():
    descr = """Get IP ranges by country"""
    parser = argparse.ArgumentParser(description=descr)
    parser.add_argument("-lc", "--listcountries", action='store_true', help="List available countries and Country Codes")
    parser.add_argument("-cc", "--countrycode", type=str, help="List ip addresses of country.")
    parser.add_argument("-i", "--info", type=str, help="Get location info of IP or domain.")
    args = parser.parse_args()
    return args
   
    
  
if __name__=='__main__':
    args = parse_args()
    
    if args.info:
        ipl = IpLocations()
        info = ipl.get_ip_location_obj(args.info)
        print 'Country: '+info['country_name']+' ('+info['country_code']+')'
        print 'City: '+info['city']
        print 'Longitude: '+str(info['longitude'])
        print 'Latitude: '+str(info['latitude'])
    
    if args.listcountries:
        for c in CountryIps().get_countries():
            print "Country: "+c[0]+" - Code: "+c[1]
    if args.countrycode:
        for ip in CountryIps().get_ips(args.countrycode.lower()):
            print ip
            
    
    

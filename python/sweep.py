#!/usr/bin/python2

import subprocess, threading, time, sys, netifaces, os

'''
Fast ping sweep

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

'''

class sweeper(object):

    def __init__(self):
        self.ups = []
        self.green =  '\033[92m'
        self.neutral = '\033[0m'
        self.header  = '\033[95m'

    def ping_(self,ip_a):
        self.cmd1 = "ping -c 1 -w 1 "+ip_a+" | grep icmp* | wc -l"
        #self.cmd2 = "arp -a | head -n 1"
        self.pping = subprocess.Popen(self.cmd1, shell=True,
                           stdout=subprocess.PIPE, 
                           stderr=subprocess.PIPE)
        for status in self.pping.stdout.readline():
            if status == "1":
                self.ups.append(ip_a)
            
                            
    def get_ip(self):
        self.gw = netifaces.gateways()
        self.ip = self.gw[2][0][0][:-1] #first three octets
 
        return self.ip
        
        
    def sweep(self):
        self.ip_ = self.get_ip()
        self.ups = []
        self.threads = []
        self.tsleep = 30
        print self.header+"Sweeping network"+self.neutral
        for i in range(1, 256):
            self.t = threading.Thread(target=self.ping_, args=(str(self.ip_) + str(i),))
            self.threads.append(self.t)
            self.t.start()
            print ">",
            if i == self.tsleep:
                for j in self.threads:
                    j.join()
                    self.threads.remove(j)
                self.tsleep += 30
        print
        os.system('clear')
        print self.header+"--------------"+self.neutral
        for u in self.ups:
            print self.green+u+self.neutral
        print self.header+"--------------"+self.neutral
                
                
         
        
 
if __name__ == "__main__":
    sweeper().sweep()
    

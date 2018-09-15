#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import psutil
import smtplib
from email import utils
from email.mime.text import MIMEText
import subprocess
import logging
import socket
import datetime
import time

"""
Server monitoring script to put in cron.
"""

logging.basicConfig(filename='/var/log/monitor.log',level=logging.DEBUG)

class Monitor(object):

    def __init__(self):
        self.time = str(datetime.datetime.now())

    def disk_full(self, disk=None, max_usage=float(85)):
        self.max_usage = max_usage
        # Get usage percanage of the disk
        if disk:
            self.disk = disk
            self.usage_percantage =  psutil.disk_usage(self.disk)[3]
        else:
            self.usage_percantage =  psutil.disk_usage('.')[3]

        # Check if disk usage too high

        if self.usage_percantage > self.max_usage:
            logging.warning(self.time+': Disk is getting Full.')
            return True
        else:
            logging.info(self.time+': Disk usage is ok')
            return False

     def memory_usage_high(self, max_usage=float(90)):
        self.max_usage = max_usage
        try:
            self.used_per = psutil.virtual_memory()[2]
            if self.used_per > self.max_usage:
                logging.warning(self.time+': Physical memory usage high')
                return True
            else:
                logging.info(self.time+': Physical memory usage normal')
                return False
        except Exception as pse:
            logging.warning(self.time+': Couldn\'t monitor physical memory usage')
            logging.warning(str(pse))
        try:
            self.virt_mem = psutil.virtual_memory()[3]
            if self.virt_mem > self.max_usage:
                logging.warning(self.time+': Virtual memory usage high')
                return True
            else:
                logging.info(self.time+': Virtual memory usage normal')
                return False
        except Exception as pse:
            logging.warning(self.time+': Couldn\'t monitor virtual memory usage')
            logging.warning(str(pse))

    def swap_usage_high(self, max_usage=65):
        self.max_usage = max_usage
        try:
            self.swap_use = psutil.swap_memory()[3]
            if self.swap_use > self.max_usage:
                logging.warning(self.time+': Swap usage high')
                return True
            else:
                logging.info(self.time+': Swap usage normal')
                return False
        except Exception as swe:
            logging.warning(self.time+': Couldn\'t monitor swap usage')
            logging.warning(str(swe))

    def was_rebooteed(self):
        try:
            self.proc = subprocess.Popen('uptime', stdout=subprocess.PIPE)
            self.output = self.proc.stdout.read()
            if not "days" in self.output:
                logging.warning(self.time+': Server has booted during last 24 hours')
                return True
        except Exception as e:
            logging.debug(self.time+': Getting uptime failed')
            logging.warning(str(e))

class Email(object):

    def send(self, body, smtpserver, to="something"):
        self.time = str(datetime.datetime.now())
        self.content = body
        self.from_server = socket.gethostname()
        self.smtpserver = smtpserver
        self.port = 25
        self.to = to
        self.msg = MIMEText(self.content)
        self.msg['To'] = utils.formataddr(('Recipient', self.to))
        self.msg['From'] = utils.formataddr((self.from_server, self.from_server+'@putdomainhere.com'))
        self.msg['Subject'] = body

        try:
            self.smtpObj = smtplib.SMTP(self.smtpserver, self.port)
            self.smtpObj.sendmail(self.from_server, self.to, self.msg.as_string())
            logging.info(self.time+': Email was sent')
            time.sleep(5)
        except Exception as se:
            logging.debug(self.time+': Sending mail failed')


if __name__ == '__main__':
    # Add recipients here
    smtpsrv = "mysmtp.server.com"
    recipients = ['first@mailaddress.com', 'second@mailaddress@net']
    monitor = Monitor()
    e = Email()
    if monitor.disk_full():
        e.send("I'm running out of disk space!",  smtpsrv,to=recipients)
    if monitor.memory_usage_high():
        e.send("My RAM usage is quite high!", smtpsrv,to=recipients)
    if monitor.swap_usage_high():
        e.send("My swap usage is quite high!", smtpsrv,to=recipients)
    if monitor.was_rebooteed():
        e.send("Why was I rebooted lately?", smtpsrv,to=recipients)
    logging.info('--------------------------------------------------------------------------------------------------------------------')

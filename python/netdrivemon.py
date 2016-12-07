import os
import logging
import datetime
import sys

########################################
# Check if path in mapped drive exists #
# If not, try to remap drive           #
########################################

logging.basicConfig(filename = 'webdavcheck.log', level = logging.DEBUG)

logging.info('Started: ' + str(datetime.datetime.now()))


if len(sys.argv) > 4:
    server = sys.argv[1]
    driveletter = sys.argv[2]
    user = sys.argv[3]
    passw = sys.argv[4]
    print "Server is "+server
    print "Drive letter is "+driveletter
    logging.info("Server is "+server)
    logging.info("Drive letter is "+driveletter)
else:
    logging.warning('No arguments given.')
    

try:
    #####
    #Try directory listing from drive
    #####
    os.listdir(driveletter+":/")
    logging.info('Path is accessible')
except OSError as oe:
    # If path is not accessible'
    logging.warning('Path cannot be accessed')
    logging.info('Trying to re-map: ')
    ###
    # Delete mapping from drive letter and..
    ###
    os.system("NET USE "+driveletter+": /DELETE /Y")
    ###
    # ..map drive
    ###
    res = os.system('NET USE '+driveletter+': "'+server+'" /User:'+user+' '+passw)
    if res == 0:
       logging.info('Drive remapped successfully')
    else :
        logging.warning('Error (code): ' + str(res))
except Exception as e: 
    logging.debug(str(e))

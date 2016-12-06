import os
import logging
import datetime

########################################
# Check if path in mapped drive exists #
# If not, try to remap drive           #
########################################

logging.basicConfig(filename = 'webdavcheck.log', level = logging.DEBUG)

logging.info('Started: ' + str(datetime.datetime.now()))


try:
    #####
    # Put path here which is accessible IF networkd drive is mapped and connected
    #####
    os.listdir("M:/mapped/webdav/path")
    logging.info('Path is accessible')
except OSError as oe:
    # If path is not accessible'
    logging.warning('Path cannot be accessed')
    logging.info('Trying to re-map: ')
    ###
    # Put correct drive letter here...
    ###
    os.system("NET USE W: /DELETE /Y")
    ###
    # ..and here + server info
    ###
    res = os.system('NET USE W: "https://server.com" /User:username pass')
    if res == 0:
       logging.info('Drive remapped successfully')
    else :
        logging.warning('Error (code): ' + str(res))
except Exception as e: 
    logging.debug(str(e))

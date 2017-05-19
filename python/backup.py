import os
import sys
import subprocess
import shutil
import argparse
import logging
import datetime

"""
The MIT License

Copyright (c) 2017 mtask@github.com

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
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
"""

store_backups_limit=12
logging.basicConfig(filename = 'backups.log', level = logging.DEBUG)
logging.info('Started: ' + str(datetime.datetime.now()))

def check_difference(src, budst):
    backup_folder = os.path.join(budst, "backup.0")
    #os.system("ROBOCOPY "+src+" "+backup_folder+" /e /l /ns /njs /njh /ndl /fp /log:robocopy.log")
    proc = subprocess.Popen("ROBOCOPY "+src+" "+backup_folder+" /e /l /E /ns /njs /njh /ndl /fp /log:robocopy.log", stdout=subprocess.PIPE, shell=True)
    (output, err) = proc.communicate()
    if not output.strip():
        return False
    else:
        return True

def backup_folder_manager(src, budst):
    """
    Latest backup is always in backup.0 folder.
    Backup folders are renamed to backup.<num>+1.
    Except backup.0 is copied to backup.1 so only changes will be synced to backup.0 from source files
    """

    backup_folders_mixed = os.listdir(budst)
    if "backup.0" not in backup_folders_mixed:
        os.mkdir(os.path.join(budst, "backup.0"))
        return
    backup_folders =  sorted(backup_folders_mixed, reverse=True, key=lambda x: int(x.split('.')[1]))
    logging.info(backup_folders)
    # Increment folder backup.0 --> newest
    for folder in backup_folders:
        new_backup_number = int(folder.split('.')[1])+1
        if new_backup_number > store_backups_limit:
            logging.info("Hitting backup limit - removing oldest.")
            shutil.rmtree(os.path.join(budst,folder))
        elif new_backup_number == 1:
            logging.info("Copying backup.0 to backup.1")
            shutil.copytree(os.path.join(budst,folder),os.path.join(budst,"backup."+str(new_backup_number)))
        else:
            os.rename(os.path.join(budst,folder),os.path.join(budst,"backup."+str(new_backup_number)))

def backup(src, budst):
    backup_folder = os.path.join(budst, "backup.0")
    logging.info("Starting copying files to backup.0.")
    code = os.system("robocopy "+src+" "+backup_folder+"  /MIR /FFT /E /W:20 /log:robocopy.log")
    logging.info("Copying done")

def parse_args():
    descr = """
        Incremental and recursive backups for Windows folders
        """
    parser = argparse.ArgumentParser(description=descr)
    parser.add_argument("-src", "--source", type=str, help="Source files to backup")
    parser.add_argument("-dst", "--destination", type=str, help="Destination folder for backups")
    args = parser.parse_args()
    return args
      
if __name__ == '__main__':
    args = parse_args()
    src = args.source
    dst = args.destination
   
    
    if not src or not dst:
        sys.exit("Check help with '-h' switch")
    elif not os.path.isdir(src) and not os.path.isfile(src):
        logging.info("Source not found")
        sys.exit(1)
    elif not os.path.isdir(dst):
        logging.info("Destination foulder not found")
        sys.exit(1)
         
    logging.info("Source files for backup: "+src)
    logging.info("Backup destination: "+dst)
    
    if check_difference(src,dst):
        backup_folder_manager(src, dst)
        backup(src, dst)
    else:
        logging.info("No differences since previous backup")
    logging.info('Ended: ' + str(datetime.datetime.now()))
    
# scan through sub lib directories
#/usr/bin/python3
import os
import sys
import pathlib
import re

def ScanObjects(directory):
    # print(directory)
    SkipDir=os.path.join(os.getcwd(),'obj')
    # SkipDir=directory+'obj'
    
    if(os.path.isdir(directory)==False):
        return ''
    dir_content = os.listdir(directory)
    # print('scaning directory {} {}'.format(directory,os.path.basename(directory)))
    base_dir=os.path.basename(directory)
    files=[]
    if dir_content:
            
        for dir_item in dir_content:

            item_base=os.path.basename(dir_item)
            item_type=os.path.splitext(dir_item)[1]

            item_path=os.path.join(directory,dir_item)

            if(os.path.isfile(item_path) and (base_dir =='obj') and directory!=SkipDir):
                if(item_type in item_types):
                    files.append(item_path)
            elif(os.path.isdir(item_path)):
                # if(dir_item=='lib'):
                files.extend(ScanObjects(item_path))
                # pass
    return files

WorkDir=os.getcwd()
item_types=['.o']
OutputType = 0

if len(sys.argv) > 1:
    # Access the command-line arguments starting from index 1
    # sys.argv[0] is the script name itself
    if(sys.argv[1]=='list'):
        OutputType=1

ScanResults=ScanObjects(WorkDir)
#print(os.path.basename(WorkDir))
for item in ScanResults:
    if(OutputType == 0):
        print(re.sub(WorkDir+'/',"",item),end=' ')
    elif(OutputType == 1):
        print(re.sub(WorkDir+'/',"",item),end='\n')
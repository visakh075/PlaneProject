# scan through sub lib directories
#/usr/bin/python3
import os
import sys
import pathlib
import re
def Scan(directory):
    # print(directory)
    SkipDir=os.path.join(os.getcwd(),'lib')
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

            if(os.path.isfile(item_path) and (base_dir =='lib') and directory!=SkipDir):
                if(item_type in item_types):
                    files.append(item_path)
            elif(os.path.isdir(item_path)):
                # if(dir_item=='lib'):
                files.extend(Scan(item_path))
                # pass
    return files

# OutputType
# 0 for normal inclusion 
# -I libXXX.h libYYYY.h ...
# 1 as list
# libXXX.h
# libYYY.h

item_types=['.h']
OutputType = 0
LibraryPath='lib'
WorkDir=os.getcwd()


if len(sys.argv) > 1:
    # Access the command-line arguments starting from index 1
    # sys.argv[0] is the script name itself
    if(sys.argv[1]=='list'):
        OutputType=1

ScanResult=Scan(WorkDir)

# return according to output type

if(OutputType==0):
    #print as a normal inclusion
    if(len(ScanResult)):
        print('-I',end=' ')
    for item in ScanResult:
        # print(item,end=' ')
        print(re.sub(WorkDir+'/',"",item),end=' ')
elif(OutputType==1):
    for item in ScanResult:
        # print(item)
        print(re.sub(WorkDir+'/',"",item),end='\n')
# scan through sub lib directories
#/usr/bin/python3

import sys
import os.path
from os import path
w_dir=os.getcwd()
item_types=['.h']
result=[]
def obj_libs(directory):
    result=[]
    if(path.isdir(directory)):
        dir_content = os.listdir(directory)
        # print(directory)
        curr_path=os.path.basename(directory)
        # print(curr_path,'>')
        
        for dir_item in dir_content:
            #check whether this is directory and base
            base_name=path.basename(dir_item)
            abso_path=path.join(directory,dir_item)

            if(os.path.isdir(abso_path) and (curr_path=='lib')):
                result.extend(obj_libs(abso_path))
            elif(base_name=='lib'):
                result.append(abso_path)
                pass

    return(result)

lib_path='lib'
result=obj_libs(lib_path)
# print(result)
for item in result:
    print('-I {}'.format(item),end=' ')


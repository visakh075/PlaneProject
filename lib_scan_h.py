# scan through sub lib directories
#/usr/bin/python3
import os
import sys
import pathlib
w_dir=os.getcwd()
item_types=['.h']
def obj_libs(directory):
    # print(directory)
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

            if(os.path.isfile(item_path) and (base_dir =='lib')):
                if(item_type in item_types):
                    files.append(item_path)
            elif(os.path.isdir(item_path)):
                # if(dir_item=='lib'):
                files.extend(obj_libs(item_path))
                # pass
    return files

# lib_path=os.path.join(w_dir,'lib')
lib_path='lib'
result=obj_libs(lib_path)
# print(result)
for item in result:
    print(item,end=' ')


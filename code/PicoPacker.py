# PicoPacker is a tool to merge and minify lua files for use in the virtual console pico-8
# Made by @sorensaket

# imports
import os, re

#set to the file extension of "to-be-merged" files
ext = '.lua'

#set to your working directory
dir_path = os.path.dirname(os.path.realpath(__file__))
src_path = dir_path + "\\src"

#set to the name of your output file
dist = 'dist.lua'

#current data
cdata = ""

# number of files
fnum = 0

# recursively search src folder
for path, subdirs, files in os.walk(src_path):
  # for each file
  for name in files:
    # Get the file path
    f = os.path.join(path, name)
    # if the name ends with our extension type
    if  f.endswith(ext):
      fnum+=1
      # print the file path out
      print(f)
      # open the target file
      data = open(f)
      # for each line in target file
      for l in data:
          # remove all comments tabs, linefeeds and carriage returns
          s = re.sub(r'(--).*$|(//).*$|\t|\n|\r','', l)
          # if the string is not empty 
          if s:
            cdata+= s + " "
      # close file 
      data.close()
# if found any files
if fnum > 0:
  # remove unnecessary whitespace 
  cdata = re.sub(r'\s+', ' ', cdata)
  # write to dist
  with open(dist, 'w') as f:
    f.write(cdata)
  input("Success! Merged and minified " + str(fnum) + " files!")
else:
  input("No files found")
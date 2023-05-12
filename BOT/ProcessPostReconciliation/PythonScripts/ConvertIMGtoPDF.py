# -*- coding: utf-8 -*-
"""
Created on Tue Jan  5 10:03:56 2021

@author: lorenzo.fiori
"""

from PIL import Image
import os, sys


# inputfile = r'C:\ScriptAdminRoot\prova.jpg'


def convertImg2PDF(inputfile):  
    im1 = Image.open(inputfile)   
    outputpdf = os.path.splitext(inputfile)[0] + ".pdf"    
    im2 = im1.convert('RGB')
    im2.save(outputpdf)    

inputfile = sys.argv[1]

try:
    convertImg2PDF(inputfile)
    print("OK")
except:
    print("Unexpected error:",sys.exc_info()[0])
    raise
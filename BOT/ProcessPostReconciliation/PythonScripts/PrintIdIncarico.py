# -*- coding: utf-8 -*-
"""
Spyder Editor

"""


import sys
import io
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import letter
from PyPDF2 import PdfFileReader, PdfFileWriter


FileFolder = "C:\\ScriptAdminRoot\\Execute\\AZIMUT\RICONCILIATORE\\CESAM_AZ_TransferAgent_StampaRiconciliati"
File = FileFolder + "\\POBA.pdf"

# Contenuto = "16002645"
# SourceFile = File

def printIdIncarico(Contenuto,SourceFile):
    OutputFile = SourceFile.replace(".pdf","_copy.pdf")
    x = 35
    y = 820

    packet = io.BytesIO()
    # create a new PDF with Reportlab
    can = canvas.Canvas(packet, pagesize=letter)
    can.drawString(x, y, Contenuto)
    can.save()

    #move to the beginning of the StringIO buffer
    packet.seek(0)
    new_pdf = PdfFileReader(packet)
    # read your existing PDF
    existing_pdf = PdfFileReader(open(SourceFile, "rb"))


    output = PdfFileWriter()
    # add the "watermark" (which is the new pdf) on the existing page
    
    j=0
    numPages = existing_pdf.numPages
    #print(numPages)
    while j < (numPages-1): 
        #print(j)
        page = existing_pdf.getPage(j)
        scritta = new_pdf.getPage(0)      
        page.mergePage(scritta)
        output.addPage(page)
        j+=1
        
    # finally, write "output" to a real file
    outputStream = open(OutputFile, "wb")
    output.write(outputStream)
    outputStream.close()
    
    return OutputFile

Contenuto = sys.argv[1]
SourceFile = sys.argv[2]

try:    
    OutputFile = printIdIncarico(Contenuto, SourceFile)
    print(OutputFile)
except:
    print("Unexpected error:",sys.exc_info()[0])
    raise
import os, shutil
from ConvertIMGToPDF import convertImg2PDF
from MergePDFs import pdfMerge

SOURCEPATH = 'E:/Documenti/Banda Citta di Quartu/Parti da inviare ai bandisti/JPG da convertire'

def Bulk_ConvertImg2PDF(path: str):
    entries = os.listdir(path)
    os.chdir(path)
    for entry in entries:
        convertImg2PDF(inputfile=entry)


def Bulk_MergePDFsFromFolders(path: str, basename: str):
    entries = os.listdir(path)
    os.chdir(path)
    for entry in entries:
        outputfilename = f'{basename} {entry}.pdf'
        mergepath = f'{path}/{entry}'
        print(outputfilename)
        pdfMerge(path=mergepath,outputfile=outputfilename)
        

#Bulk_ConvertImg2PDF(SOURCEPATH)
#Bulk_MergePDFsFromFolders(path=SOURCEPATH, basename="Libertango")




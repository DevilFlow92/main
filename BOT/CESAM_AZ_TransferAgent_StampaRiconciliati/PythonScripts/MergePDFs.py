import sys
import os
import PyPDF2

# path = "C:\\Users\\lorenzo.fiori\\Documents\\StampeCappiello"
# outputfile = "prova.pdf"


def pdfMerge(path, outputfile):
    #userpdflocation=input('Folder path to PDFs that need merging: ')
    userpdflocation = path
    os.chdir(userpdflocation)

    #userfilename=input('What sould i call the file? ')
    userfilename = outputfile
    pdf2merge = []
    for inputfile in os.listdir('.'):
        if inputfile.endswith('.pdf'):
            # print(inputfile)
            pdf2merge.append(inputfile)

    pdfWriter = PyPDF2.PdfFileWriter()

    for filename in pdf2merge:
        #print(filename)
        pdfFileObj = open(filename, 'rb')
        pdfReader = PyPDF2.PdfFileReader(pdfFileObj)

        for pageNum in range(pdfReader.numPages):
            pageObj = pdfReader.getPage(pageNum)
            pdfWriter.addPage(pageObj)

    pdfOutput = open(userfilename, 'wb')
    pdfWriter.write(pdfOutput)
    pdfOutput.close()

try:
    path = sys.argv[1]
    outputfile = sys.argv[2]
    pdfMerge(path, outputfile)
    print("OK")
except:
    print("Unexpected error:",sys.exc_info()[0])
    raise


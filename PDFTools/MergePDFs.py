import sys, os, argparse
import PyPDF2

parser = argparse.ArgumentParser(description="Merge PDFs into one")
parser.add_argument("-path",
                    action="store",
                    help="Path of PDFs to merge",                    
)
parser.add_argument(
    "-outputfilename",
    action="store",
    help="Name of PDF to obtain",
)
args = parser.parse_args()

def pdfMerge(path, outputfile):
    #userpdflocation=input('Folder path to PDFs that need merging: ')
    os.chdir(path)
    #userfilename=input('What sould i call the file? ')
    userfilename = outputfile
    pdf2merge = []
    for inputfile in os.listdir('.'):
        if inputfile.endswith('.pdf'):
            # print(inputfile)
            pdf2merge.append(inputfile)

    pdfWriter = PyPDF2.PdfWriter()

    for filename in pdf2merge:
        #print(filename)
        pdfFileObj = open(filename, 'rb')
        pdfReader = PyPDF2.PdfReader(pdfFileObj)

        for pageNum in range(len(pdfReader.pages)):
            pageObj = pdfReader.pages[pageNum]
            pdfWriter.add_page(pageObj)

    pdfOutput = open(userfilename, 'wb')
    pdfWriter.write(pdfOutput)
    pdfOutput.close()
    pdfFileObj.close()
   


if __name__ == "__main__":
    try:
        pdfMerge(path=args.path,outputfile=args.outputfilename)
        print("OK")
    except:
        print("Unexpected error:",sys.exc_info()[0])
        raise


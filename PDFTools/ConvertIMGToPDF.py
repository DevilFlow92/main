from PIL import Image
import os, sys, argparse

parser = argparse.ArgumentParser(description="Convert Image to PDF")
parser.add_argument("-filepath",
    action="store",
    help= "Path to the Image. Use / instead of \\",
)
args = parser.parse_args()

def convertImg2PDF(inputfile):
    im1 = Image.open(inputfile)
    outputpdf = os.path.splitext(inputfile)[0] + '.pdf'
    im2 = im1.convert('RGB')
    im2.save(outputpdf)

inputfile = sys.argv[1]

if __name__ == "__main__":    
        try:
            convertImg2PDF(inputfile=args.filepath)
            print("OK")
        except:
            print("Unexpected error:",sys.exc_info()[0])
            raise
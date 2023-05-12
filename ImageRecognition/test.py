#import time
from PIL import Image
from statistics import mean
from collections import Counter
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import style
import argparse

style.use("ggplot")
IMAGE_PATH = "E:/Immagini/DevilFlow92/ImageRecognition"

parser = argparse.ArgumentParser(description="Test Image Recognition")
parser.add_argument("--create", action="store_true",help="Create a model to recognize numbers.")
parser.add_argument("--test", action="store_true", help="Test the model with guess a number into an image.")
parser.add_argument(
    "-FromImagedb",
    action="store",
    default='0',
    choices=['1', '0'],
    help="Set if the images is from imagedb path E:/Immagini/DevilFlow92/ImageRecognition/images."
    
    )
parser.add_argument(
    "-f",
    action="store",
    help="Path to an image with a number to guess. Pass only image file if it is from imagedb path."
)

args = parser.parse_args()

def createExamples():
    numberArrayExamples = open('numArEx.txt','a')
    numberWeHave = range(0,10)
    versionsWeHave = range(1,10)

    for eachNum in numberWeHave:
        for eachVer in versionsWeHave:
            #print(str(eachNum)+'.'+str(eachVer))
            imgFilePath = f'{IMAGE_PATH}/images/numbers/'+str(eachNum)+'.'+str(eachVer)+'.png'
            ei = Image.open(imgFilePath)
            eiar = np.array(ei)
            eiar = eiar.copy() # i use copy because with new versions of numpy is not possible to doing math on original images
            eiar1 = str(eiar.tolist())

            lineToWrite = str(eachNum)+'::'+eiar1+'\n'
            numberArrayExamples.write(lineToWrite)


def threshold(imageArray):
    balanceAr = []
    newAr = imageArray
    for eachrow in imageArray:
        for eachPix in eachrow:
            avgNum = mean(eachPix[:3])
            balanceAr.append(avgNum)

    balance = mean(balanceAr)
    for eachRow in newAr:
        for eachPix in eachRow:
            if mean(eachPix[:3]) > balance:
                eachPix[0] = 255
                eachPix[1] = 255
                eachPix[2] = 255
                eachPix[3] = 255
            else:
                eachPix[0] = 0
                eachPix[1] = 0
                eachPix[2] = 0
                eachPix[3] = 255

    return newAr


def whatNumIsThis(filePath, from_imagedb = '0'):
    if from_imagedb == '1':
        filePath = f'{IMAGE_PATH}/images/{filePath}'

    matchedAr = []
    loadExamps = open('numArEx.txt','r').read()
    loadExamps = loadExamps.split('\n')

    i = Image.open(filePath)
    iar = np.array(i)
    iar = threshold(iar)
    iarl = iar.tolist()

    inQuestion = str(iarl)

    for eachExample in loadExamps:
        try:
            splitEx = eachExample.split('::')
            currentNum = splitEx[0]
            currentAr = splitEx[1]

            eachPixEx = currentAr.split('],')
            eachPixInQ = inQuestion.split('],')

            x=0
            while x < len(eachPixEx):
                if eachPixEx[x] == eachPixInQ[x]:
                    matchedAr.append(int(currentNum))

                x+=1
        except Exception as ex:
            print(str(ex))

    #print(matchedAr)
    m = Counter(matchedAr)
    print(m)

    graphX = []
    graphY = []
    ylimi = 0

    for eachThing in m:
        graphX.append(eachThing)
        graphY.append(m[eachThing])
        ylimi = m[eachThing]        
    
    ax1 = plt.subplot2grid((4,4), (0,0), rowspan=1, colspan=4)
    ax2 = plt.subplot2grid((4,4), (1,0), rowspan=3, colspan=4)

    ax1.imshow(iar)
    ax2.bar(graphX,graphY, align='center')
    plt.ylim(ylimi)

    xloc = plt.MaxNLocator(12)
    ax2.xaxis.set_major_locator(xloc)
    
    plt.show()


if __name__ == "__main__":
    if args.create:
        createExamples()
    if args.test:
        whatNumIsThis(filePath=args.f,from_imagedb=args.FromImagedb)
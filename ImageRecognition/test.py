#import time
from PIL import Image
from statistics import mean
from collections import Counter
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import style
style.use("ggplot")

def createExamples():
    numberArrayExamples = open('numArEx.txt','a')
    numberWeHave = range(0,10)
    versionsWeHave = range(1,10)

    for eachNum in numberWeHave:
        for eachVer in versionsWeHave:
            #print(str(eachNum)+'.'+str(eachVer))
            imgFilePath = 'images/numbers/'+str(eachNum)+'.'+str(eachVer)+'.png'
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


def whatNumIsThis(filePath):
    matchedAr = []
    loadExamps = open('numArEx.txt','r').read()
    loadExamps = loadExamps.split('\n')

    i = Image.open(filePath)
    iar = np.array(i)
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
    
    fig = plt.figure()
    ax1 = plt.subplot2grid((4,4), (0,0), rowspan=1, colspan=4)
    ax2 = plt.subplot2grid((4,4), (1,0), rowspan=3, colspan=4)

    ax1.imshow(iar)
    ax2.bar(graphX,graphY, align='center')
    plt.ylim(ylimi)

    xloc = plt.MaxNLocator(12)
    ax2.xaxis.set_major_locator(xloc)
    
    plt.show()


'''
i = Image.open('images/numbers/0.1.png')
iar = np.asarray(i)
iar = iar.copy() # i use copy because with new versions of numpy is not possible to doing math on original images

i2 = Image.open('images/numbers/y0.4.png')
iar2 = np.asarray(i2)
iar2 = iar2.copy()

i3 = Image.open('images/numbers/y0.5.png')
iar3 = np.asarray(i3)
iar3 = iar3.copy()

i4 = Image.open('images/sentdex.png')
iar4 = np.asarray(i4)
iar4 = iar4.copy()

iar = threshold(iar)
iar2 = threshold(iar2)
iar3 = threshold(iar3)
iar4 = threshold(iar4)


fig = plt.figure()
ax1 = plt.subplot2grid((8,6),(0,0), rowspan=4, colspan=3)
ax2 = plt.subplot2grid((8,6),(4,0), rowspan=4, colspan=3)
ax3 = plt.subplot2grid((8,6),(0,3), rowspan=4, colspan=3)
ax4 = plt.subplot2grid((8,6),(4,3), rowspan=4, colspan=3)

ax1.imshow(iar)
ax2.imshow(iar2)
ax3.imshow(iar3)
ax4.imshow(iar4)

plt.show()
'''

createExamples()
whatNumIsThis('images/test.png')
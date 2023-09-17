# pyautogui commands: https://pyautogui.readthedocs.io/en/latest/mouse.html
import pyautogui, time, argparse

parser = argparse.ArgumentParser(description="BOT Top Eleven")
parser.add_argument("--MouseMonitoring",action="store_true",help="Developer Only. Mouse Monitoring to capture cursors")
parser.add_argument("--GreenFarm", action="store_true",help="It will farm 25 green kits watching video ads.")
parser.add_argument("--Training", action="store_true",help="It will do the early morning training of your players.")
parser.add_argument("--BlueFarm", action="store_true",help="It will farm 5 blue kits watching video ads.")
parser.add_argument("--RedFarm", action="store_true", help="It will farm 5 red kits watching video ads.")
args = parser.parse_args()

def getposition_manually():
    print('Press Ctrl-C to quit.')
    try:
        while True:
            x,y = pyautogui.position()
            positionStr = f'X: {str(x).rjust(4)} Y: {str(y).rjust(4)}'
            print(positionStr, end='')
            print('\b' * len(positionStr), end='', flush=True)
    except KeyboardInterrupt:
        print('\n')

def move_and_click(x:int, y:int,doubleclick:bool=False, timesleep:bool=True):
    pyautogui.moveTo(x,y)
    pyautogui.click() if doubleclick is False else pyautogui.doubleClick
    if timesleep is True:
        time.sleep(2)

####### Farming Kits ############
def plus_green():
    move_and_click(1274,40)

def plus_reds():
    move_and_click(1682,40)

def plus_blues():
    move_and_click(1479,40)

def watch_video():
    move_and_click(1772,241) #click for video
    move_and_click(80,79) #disable audio
    time.sleep(40) #wait video
    move_and_click(1855,62) #close ad

def farm_greens():
    plus_green()
    time.sleep(20)
    for i in range(25):
        watch_video()
        plus_green()
        time.sleep(3)

def farm_reds():
    plus_reds()
    time.sleep(20)
    for i in range(5):
        watch_video()
        plus_reds()
        time.sleep(3)

def farm_blues():
    plus_blues()
    time.sleep(20)
    for i in range(5):
        watch_video()
        plus_blues()
        time.sleep(3)
########## End Of Farming Kits #####

########## Training ##########
def select_players():
    x = 52
    y = 289
    for i in range(10):
        move_and_click(x,y,timesleep=False)
        y+= 80
    pyautogui.scroll(-100)
    time.sleep(1)
    move_and_click(x,875,timesleep=False)
    move_and_click(x,963)
    move_and_click(1796,754) #done!

def routine_titolari_1():
    #### selecting players ####
    move_and_click(405,759)
    select_players()  
    time.sleep(2)
    ### select exercises ###
    move_and_click(1500,760)
    '''To Do. Drag exercises'''
    move_and_click(1763,1011)
    time.sleep(3)
    move_and_click(947,386)

def routine_titolari_2():
    #### selecting players ####
    move_and_click(405,759)
    select_players()
    time.sleep(2)
    ### select exercises ###
    move_and_click(1500,760)
    '''To Do. Drag exercises'''
    move_and_click(1763,1011)
    time.sleep(3)
    move_and_click(947,386)

def routine_riserve(videox2:bool=True):    
    move_and_click(405,759)
    pyautogui.scroll(-540)
    time.sleep(3)
    select_players()
    time.sleep(2)
    ### select exercises ###
    move_and_click(1500,760)
    '''To Do. Drag exercises'''
    move_and_click(1763,1011)
    time.sleep(3)
    move_and_click(947,386) if videox2 is True else move_and_click(956,509)

def training():
    move_and_click(23,73) #main left menu
    move_and_click(46,200) #training
    time.sleep(3)
    #routine_titolari_1()
    #time.sleep(5)
    #routine_titolari_2()
    #time.sleep(5)
    routine_riserve()
    time.sleep(5)
    #routine_riserve(videox2=True)
####### End Of Training #######

if __name__ == "__main__":
    if args.MouseMonitoring:
        getposition_manually()
    if args.GreenFarm:
        farm_greens()
    if args.Training:
        training()
    if args.BlueFarm:
        farm_blues()
    if args.RedFarm:
        farm_reds()

# -*- coding: utf-8 -*-
"""
Spyder Editor
Created on 19/11/2020

@author: lorenzo.fiori.
"""
import sys
import os
import textwrap
import string
from reportlab.pdfgen import canvas
from reportlab.lib.units import inch



folder = "C:\\ScriptAdminRoot\\Execute\\AZIMUT\\RICONCILIATORE\\CESAM_AZ_TransferAgent_StampaRiconciliati"
dstfile = folder+"\\BlankPageCopy.pdf"

SourceFile = dstfile

# IdIncarico = "16395941"
# IdMovimentoContoBancario = ["1253117","1253118","1253119","1253120","1253121"]
# Importo = ["50000.00","50000.00","40000.00","40000.00","30000.00"]
# DataValuta = ["23/11/2020","23/11/2020","23/11/2020","23/11/2020","23/11/2020"]
# DataContabile = ["23/11/2020","23/11/2020","23/11/2020","23/11/2020","23/11/2020"]
# ABI = ["05034","05034","05034","05034","05034"]
# CAB = ["57570","57570","57570","57570","57570"]
# NumeroConto = ["0740 0094 6325"]
# Ordinante = ["MARILENA BATTAGLIA","MARILENA BATTAGLIA","MARILENA BATTAGLIA","MARILENA BATTAGLIA","N/D"]
# Causale = ["Versamento aggiuntivo Battaglia Marilena - AZ Bond Enhanced Yield","Versamento aggiuntivo Battaglia Marilena - AZ Bond Enhanced Yield","aaaaaaaaaaaaaaaaaaaaaaaaaaah","aaaaaaaaaaaaaaaaaaaaaaaaaaah","eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee eeeeeeeeaaaaaaaaaaaaaaaaaaaaaaaaaaah"]
# NotaAggiuntiva = ["Nessuna","domani pure","domani pure","domani pure","domani pure"]
# DettaglioProdotti = ["i9f - 10.000,00 , i9g - 20.000,00 , i9h - 10.000,00"]

# IdIncarico = "17250767"
# IdMovimentoContoBancario = ["1374706"]
# Importo = ["1.193.170,00"]
# DataValuta = ["02/03/2021"]
# DataContabile = ["02/03/2021"]
# ABI = ["03041"]
# CAB = ["01600"]
# NumeroConto = ["3134 9930 0001"]
# Ordinante = ["2000777AZIMUT CAPITAL MANAGEMENT S"]
# Causale = ["SOTTOSCRIZIONE FONDI AZ FUND 1"]
# # NotaAggiuntiva = ["Bonifico TEST dfhjsdahlfdasiouewqcociopnklsdaklopidsfaojhsdafksadfè0pcsakcdlnkweafoiwenklsd"]
# NotaAggiuntiva = ["maxfunds"]
# ImportoIncarichi = ["400.000,00"]
# DettaglioProdotti = ["S6 - 200.000,00 ; T0 - 200.000,00"]


def convert(string):
    li = list(string.split("§"))
    return li

def replaceND(stringa):
    newstring = stringa.replace("N/D", "")
    return newstring

def printTextToPDF(IdIncarico
                   ,IdMovimentoContoBancario
                   ,Importo
                   ,DataValuta
                   ,DataContabile
                   ,ABI,CAB
                   ,Ordinante
                   ,Causale
                   ,NotaAggiuntiva
                   ,SourceFile
                   ,ImportoIncarichi
                   ,DettaglioProdotti
                   ,NumeroConto
                   ):
    try:
        can = canvas.Canvas(SourceFile)
        x = 30
        y = 800
        
        num_movimenti= len(IdMovimentoContoBancario)        
        
        j= 0
        while j <= (num_movimenti -1): 
   
            if y < 180:            
                can.showPage() #questo comando serve a far andare il writer nella pag successiva
                y = 800
                
           
            #Testo.setFont("Helvetica",12)
            can.setFont("Helvetica", 14)
            can.drawString(x, y, "******************************************************************************************************")
            y-=15
                   
            stringhe = [ "IdIncarico: " + IdIncarico
                        ,"Totale Somma Operazioni legate all'incarico: " + ImportoIncarichi[j]
                        ,"Data Valuta: " + replaceND(DataValuta[j])
                        ,"Importo Contabile: " + replaceND(Importo[j])
                        ,"Data Contabile: " + replaceND(DataContabile[j]) 
                        ,"ABI: " + replaceND(ABI[j])
                        ,"CAB: " + replaceND(CAB[j]) 
                        ,"C/C: " + NumeroConto[j]
                        ,"Riferimento Ordinante: " + replaceND(Ordinante[j])                 
                        ]                  
    
            for i in  stringhe:
                if i.startswith("Data Valuta: ") or i.startswith("Data Contabile: ") or i.startswith("Importo Contabile: ") or i.startswith("Ordinante: "):
                    can.setFont("Helvetica", 16)           
                        
                else:
                    can.setFont("Helvetica", 14)                                  
               
                can.drawString(x, y, i)
                
                if i.startswith("Importo Contabile: ") or i.startswith("Data Contabile: ") or i.startswith("Totale Somma") or i.startswith("C/C:"):
                    y-=25
                else:
                    y-=15
                    
            y-= 10
            StringaCausale = ""
            StringaCausale = "Causale: " + replaceND(Causale[j]) 
            can.setFont("Helvetica", 16)
            for line in textwrap.wrap(StringaCausale,60):
                
                can.drawString(x, y, line)
                y-=20
            
            can.setFont("Helvetica-Bold", 20)    
            can.drawString(x, y, "-----------------------------------------------------------------------------------")  
            y-= 20   
            NoteBonifici = ""
            NoteBonifici = "Note ufficio bonifici: " + NotaAggiuntiva[j]
            
            
            
            for line in textwrap.wrap(NoteBonifici,55):
                can.drawString(x, y, line)
                y-=20
                
            can.drawString(x, y, "-----------------------------------------------------------------------------------")
            y -=20
            
            can.setFont("Helvetica", 16)
            can.drawString(x, y, "Id Movimento: " + IdMovimentoContoBancario[j])
            y -= 30
            
            can.setFont("Helvetica", 14)
            
            StringaDettaglioProdotti = ""
            StringaDettaglioProdotti = "Dettaglio singole operazioni (CODICE - IMPORTO): " + replaceND(DettaglioProdotti[j])
            for line in textwrap.wrap(StringaDettaglioProdotti,80):
                can.drawString(x, y, line)
                y-=15
                
            y-=15        
            can.drawString(x, y, "******************************************************************************************************")
            y-= 30
            
            j += 1 #incremento contatore j (quanti movimenti ho)
            
        can.save()
        #os.system(SourceFile) #commentare in produzione, questo comando serve per aprire il file pdf
    except:
        print("Unexpected error:",sys.exc_info()[0])
        raise
        

IdIncarico = sys.argv[1]
IdMovimentoContoBancario = convert(sys.argv[2])
Importo = convert(sys.argv[3])
DataValuta = convert(sys.argv[4])
DataContabile = convert(sys.argv[5])
ABI = convert(sys.argv[6])
CAB = convert(sys.argv[7])
Ordinante = convert(sys.argv[8])
Causale = convert(sys.argv[9])
NotaAggiuntiva = convert(sys.argv[10])
SourceFile = sys.argv[11]
ImportoIncarichi = convert(sys.argv[12])
DettaglioProdotti = convert(sys.argv[13])
NumeroConto = convert(sys.argv[14])


try:
    
    printTextToPDF(IdIncarico
               ,IdMovimentoContoBancario
               ,Importo
               ,DataValuta,DataContabile
               ,ABI,CAB
               ,Ordinante
               ,Causale
               ,NotaAggiuntiva
               ,SourceFile
               ,ImportoIncarichi
               ,DettaglioProdotti
               ,NumeroConto
               )
    print("OK")
except:
    print("Unexpected error:",sys.exc_info()[0])
    raise
        

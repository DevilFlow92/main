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

# SourceFile = dstfile

# IdIncarico = "16395941"
# IdMovimentoContoBancario = ["1253117","1253118","1253119","1253120","1253121"]
# Importo = ["50000.00","50000.00","40000.00","40000.00","30000.00"]
# DataValuta = ["23/11/2020","23/11/2020","23/11/2020","23/11/2020","23/11/2020"]
# DataContabile = ["23/11/2020","23/11/2020","23/11/2020","23/11/2020","23/11/2020"]
# ABI = ["05034","05034","05034","05034","05034"]
# CAB = ["57570","57570","57570","57570","57570"]
# Ordinante = ["MARILENA BATTAGLIA","MARILENA BATTAGLIA","MARILENA BATTAGLIA","MARILENA BATTAGLIA","N/D"]
# Causale = ["Versamento aggiuntivo Battaglia Marilena - AZ Bond Enhanced Yield","Versamento aggiuntivo Battaglia Marilena - AZ Bond Enhanced Yield","aaaaaaaaaaaaaaaaaaaaaaaaaaah","aaaaaaaaaaaaaaaaaaaaaaaaaaah","eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee eeeeeeeeaaaaaaaaaaaaaaaaaaaaaaaaaaah"]
# NotaAggiuntiva = ["Nessuna","domani pure","domani pure","domani pure","domani pure"]


# IdIncarico = "16395941"
# IdMovimentoContoBancario = ["1253117"]
# Importo = ["50.000,00"]
# DataValuta = ["23/11/2020"]
# DataContabile = ["23/11/2020"]
# ABI = ["05034"]
# CAB = ["57570"]
# Ordinante = ["TEST COGNOME TEST NOME"]
# Causale = ["Versamento aggiuntivo TEST COGNOME TEST NOME - AZ Bond Enhanced Yeld TEST"]
# NotaAggiuntiva = ["Bonifico TEST"]
# ImportoIncarichi = ["50.000,00"]
# DettaglioProdotti = ["i9f - 10.000,00 , i9g - 20.000,00 , i9h - 10.000,00"]


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
                   ):
    try:
        can = canvas.Canvas(SourceFile)
        x = 35
        y = 800
        
        num_movimenti= len(IdMovimentoContoBancario)        
        
        j= 0
        while j <= (num_movimenti -1): 
   
            if y < 180:            
                can.showPage()
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
                        ,"Riferimento Ordinante: " + replaceND(Ordinante[j])                 
                        ]                  
    
            for i in  stringhe:
                if i.startswith("Data Valuta: ") or i.startswith("Data Contabile: ") or i.startswith("Importo Contabile: ") or i.startswith("Ordinante: "):
                    can.setFont("Helvetica", 16)           
                        
                else:
                    can.setFont("Helvetica", 14)                                  
               
                can.drawString(x, y, i)
                
                if i.startswith("Importo Contabile: ") or i.startswith("Data Contabile: ") or i.startswith("Totale Somma"):
                    y-=25
                else:
                    y-=15
                    
            y-= 10
            StringaCausale = ""
            StringaCausale = "Causale: " + replaceND(Causale[j]) 
            can.setFont("Helvetica", 16)
            for line in textwrap.wrap(StringaCausale,60):
                
                can.drawString(x, y, line)
                y-=15
                
            y-= 10      
            NoteBonifici = ""
            NoteBonfici = NotaAggiuntiva[j]
            
            can.setFont("Helvetica", 16)
            can.drawString(x, y, "Note ufficio bonifici: " + NoteBonfici)
            y -=18
            
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
        #os.system(SourceFile)
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
               )
    print("OK")
except:
    print("Unexpected error:",sys.exc_info()[0])
    raise
        

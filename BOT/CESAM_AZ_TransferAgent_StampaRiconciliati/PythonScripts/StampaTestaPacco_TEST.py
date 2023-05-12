# -*- coding: utf-8 -*-
"""
Created on Fri Mar 26 15:33:32 2021

@author: lorenzo.fiori
"""

import sys
import os
import textwrap
from reportlab.pdfgen import canvas



folder = "C:\\ScriptAdminRoot\\Execute\\AZIMUT\\RICONCILIATORE\\CESAM_AZ_TransferAgent_StampaRiconciliati"
dstfile = folder+"\\BlankPageCopy.pdf"

SourceFile = dstfile



IdIncarico = "17404140"
IdMovimentoContoBancario = ["1398898"]
Importo = ["6.490,53"]
DataValuta = ["25/03/2021"]
DataContabile = ["25/03/2021"]
ABI = ["05034"]
CAB = ["11701"]
NumeroConto = ["0000 0007 0041"]
Ordinante = ["CONTO RIMBORSI CASE TERZE AFB "]
Causale = ["BATTAGLIA MARIA CARMELA - AFB"]
NotaAggiuntiva = ["Bonifico TEST dfhjsdahlfdasiouewqcociopnklsdaklopidsfaojhsdafksadfè0pcsakcdlnkweafoiwenklsd"]
#NotaAggiuntiva = ["1 TRANCHE, 6.490,53 il 26/03"]
ImportoIncarichi = ["15.970,32"]
DettaglioProdotti = ["I9 - 15.970,32"]
TipoDispositiva = ["PIC + MultiPAC"]


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
                   ,TipoDispositiva
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
            
            
            
            for line in textwrap.wrap(NoteBonifici,50):
                can.drawString(x, y, line)
                y-=20
                
            can.drawString(x, y, "-----------------------------------------------------------------------------------")
            y -=20
            
            can.setFont("Helvetica", 16)
            can.drawString(x, y, "Id Movimento: " + IdMovimentoContoBancario[j])
            y -= 20
            
            can.drawString(x, y, "Tipologia Prodotto: " + TipoDispositiva[j])
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
        os.system(SourceFile) #commentare in produzione, questo comando serve per aprire il file pdf
    except:
        print("Unexpected error:",sys.exc_info()[0])
        raise
        

# IdIncarico = sys.argv[1]
# IdMovimentoContoBancario = convert(sys.argv[2])
# Importo = convert(sys.argv[3])
# DataValuta = convert(sys.argv[4])
# DataContabile = convert(sys.argv[5])
# ABI = convert(sys.argv[6])
# CAB = convert(sys.argv[7])
# Ordinante = convert(sys.argv[8])
# Causale = convert(sys.argv[9])
# NotaAggiuntiva = convert(sys.argv[10])
# SourceFile = sys.argv[11]
# ImportoIncarichi = convert(sys.argv[12])
# DettaglioProdotti = convert(sys.argv[13])
# NumeroConto = convert(sys.argv[14])
# TipoDispositiva = convert(sys.argv[15])


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
               ,TipoDispositiva
               )
    print("OK")
except:
    print("Unexpected error:",sys.exc_info()[0])
    raise
        

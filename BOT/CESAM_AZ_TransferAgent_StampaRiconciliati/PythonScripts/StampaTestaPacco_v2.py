# -*- coding: utf-8 -*-
"""
Created on Fri Mar 26 15:33:32 2021

@author: lorenzo.fiori
"""

import sys
import textwrap
from reportlab.pdfgen import canvas

# è hardcoded, il file deve essere questo e non può cambiare, altrimenti il processo non parte
#è un file bianco dal quale scrivere info stampabili
SourceFile = "C:\\ScriptAdminRoot\\Execute\\AZIMUT\\RICONCILIATORE\\CESAM_AZ_TransferAgent_StampaRiconciliati\\BlankPageCopy.pdf"

## decommentato. son da usare se e solo se lo script è da eseguire in locale e non da un robot acceso secondo 
## il processo

# IdIncarico = "17404140"
# IdMovimentoContoBancario = ["1398898"]
# Importo = ["6.490,53"]
# DataValuta = ["25/03/2021"]
# DataContabile = ["25/03/2021"]
# ABI = ["05034"]
# CAB = ["11701"]
# NumeroConto = ["0000 0007 0041"]
# Ordinante = ["CONTO RIMBORSI CASE TERZE AFB "]
# Causale = ["BATTAGLIA MARIA CARMELA - AFB"]
# # NotaAggiuntiva = ["Bonifico TEST dfhjsdahlfdasiouewqcociopnklsdaklopidsfaojhsdafksadfè0pcsakcdlnkweafoiwenklsd"]
# NotaAggiuntiva = ["1 TRANCHE, 6.490,53 il 26/03"]
# ImportoIncarichi = ["15.970,32"]
# DettaglioProdotti = ["I9 - 15.970,32"]
# TipoDispositiva = ["PIC + MultiPAC"]


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
        can = canvas.Canvas(SourceFile) #canvas, dal nome in inglese appunto tela, il file bianco
                                        #sarà trattato come una tela sulla quale poter scrivere/disegnare
                                        #il desiderata
        x = 30
        y = 800
        
        num_movimenti= len(IdMovimentoContoBancario) #conto quanti movimenti risultano
                                                    #per idincarico, deve partire un ciclo dinamico
                                                    #in cui stampare i dati della contabile su foglio bianco
        
        j= 0
        while j <= (num_movimenti -1): #all'ultimo movimento devo finire, non vado oltre
                                        #metto -1 perché il python ragiona con primo numero 0
   
            if y < 180: #numero fisso che consiglio di non variare onde evocare madonne grafiche
                        #perché è la posizione precisa in cui cambio 
                        #pagina del canvas
                        
                can.showPage() #questo comando serve a far andare il writer nella pag successiva
                y = 800 #posizione precisa di inizio pagina del canvas 
                
          
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
                    can.setFont("Helvetica", 16) #è stato richiesto che date e importo contabile fossero stampate
                                                #più in grande, quindi setto una grandezza di font più grande
                        
                else:
                    can.setFont("Helvetica", 14) #tutti gli altri casi, font standard accordato come 14                             
               
                can.drawString(x, y, i)
                
                if i.startswith("Importo Contabile: ") or i.startswith("Data Contabile: ") or i.startswith("Totale Somma") or i.startswith("C/C:"):
                    y-=25 #più spaziatura quando devo stampare importi e date
                else:
                    y-=15
                    
            y-= 10
            StringaCausale = "Causale: " + replaceND(Causale[j]) 
            can.setFont("Helvetica", 16)
            for line in textwrap.wrap(StringaCausale,60): #qui wrappo per fare in modo che la stringa grande della causale
                                                            #sia stampabile e leggibile sul canvas
                                                            #se non lo faccio, vado su una sola linea e vedrò
                                                            #solo la parte della scritta che sta sul foglio e il resto
                                                            #non lo vedo.
                                                            #in altri termini: vado a capo a seconda della grandezza della stringa
                
                can.drawString(x, y, line)
                y-=20
            
            can.setFont("Helvetica-Bold", 20)    
            can.drawString(x, y, "-----------------------------------------------------------------------------------")  
            y-= 20   
            NoteBonifici = "Note ufficio bonifici: " + NotaAggiuntiva[j]
            
            for line in textwrap.wrap(NoteBonifici,50): #anche qui wrappo le note degli operatori per le stesse ragioni
                                                        #scritte per la causale
                                                        #effettivamente potevo costruire una funzione e risparmiare
                                                        #qualche riga di codice, ma non c'avevo voglia
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
            
            StringaDettaglioProdotti = "Dettaglio singole operazioni (CODICE - IMPORTO): " + replaceND(DettaglioProdotti[j])
            for line in textwrap.wrap(StringaDettaglioProdotti,80):
                can.drawString(x, y, line)
                y-=15
                
            y-=15        
            can.drawString(x, y, "******************************************************************************************************")
            y-= 30
            
            j += 1 #incremento contatore j (quanti movimenti ho)
            
        can.save()

    except:
        print("Unexpected error:",sys.exc_info()[0])
        raise
        
#tutti questi parametri vengono da passati dal robot (o powershell) che esegue lo script
#chiaramente il robot deve passarli in questo preciso ordine
#se si intende eseguire il processo in locale, commentare tutti questi e decommentare quelli sopra.

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
TipoDispositiva = convert(sys.argv[15])


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
    
except Exception as ex:
    print("Unexpected error:",sys.exc_info()[0])
    raise ex #raiso errore, così il robot (o powershell) che esegue questo sa che qualcosa è andato storto.
        

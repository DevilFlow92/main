import PyPDF2
import re
import sys

if not sys.warnoptions:
    import warnings
    warnings.simplefilter("ignore")

#document = r"H:\Documenti\PROCESSI\ANTIRICICLAGGIO\INDAGINI FINANZIARIE CANALE PEC\TEST\massimiliano conte.pdf"
    
def extractfrompdf(document):
    try:
        pdffile = open(document,"rb")
        pdfread = PyPDF2.PdfFileReader(pdffile)
        pageobj = pdfread.getPage(0)
        text0page = pageobj.extractText()      
        
        codicefiscale = re.search("Codice fiscale ([a-zA-Z]{6}..........)\nPartita IVA",text0page).group(1)
        
        #print(codicefiscale)
        nome = re.search("Nome (.*)\nCognome",text0page).group(1)
        
        #print(nome)
        cognome = re.search("Cognome (.*)\nDenominazione",text0page).group(1)
        #print(cognome)
        
        codicerichiesta = re.search("Codice univoco della richiesta (.*)\nCodice organo procedente",text0page).group(1)
        datarichiesta = re.search("Data richiesta (.*)\nCodice struttura richiedente",text0page).group(1)
        
        codiceorgano = re.search("Codice organo procedente (.*)\nProtocollo richiesta",text0page).group(1) 
      
        strutturaRich = re.search("Descrizione struttura richiedente (.*)\nCodice fiscale richiedente",text0page).group(1)
        
        datainizioindagine = re.search("Data inizio indagine (.*)\nData fine indagine",text0page).group(1)
        
        datafineindagine = re.search("Data fine indagine (.*)\nTipo richiesta",text0page).group(1)
        
        codiceentesegnalante = re.search("Codice fiscale operatore finanziario (.*)\nTermine risposta",text0page).group(1)
        
        strutturaAuth = re.search("Descrizione struttura autorizzante (.*)\nData inizio indagine",text0page).group(1)

    finally:
        pdffile.close()
        return codicefiscale, nome, cognome, codicerichiesta,datarichiesta, codiceorgano, strutturaRich, datainizioindagine, datafineindagine, codiceentesegnalante, strutturaAuth
        

nomefile = sys.argv[1]
#nomefile = document

#print(nomefile)

codicefiscale, nome, cognome, codicerichiesta,datarichiesta, codiceorgano, strutturaRich, datainizioindagine, datafineindagine, codiceentesegnalante, strutturaAuth = extractfrompdf(nomefile)
print(codicefiscale)
print(nome)
print(cognome)
print(codicerichiesta)
print(datarichiesta)
print(codiceorgano)
print(strutturaRich)
print(datainizioindagine)
print(datafineindagine)
print(codiceentesegnalante)
print(strutturaAuth)
from feeds.tasks import ReadDB
import pandas as pd
import numpy as np
from reportlab.lib import colors
from reportlab.pdfgen.canvas import Canvas
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.platypus import Paragraph, Frame, Table, Spacer, TableStyle

LOGO = 'E:/Documenti/Banda Citta di Quartu/Logo Quartu.png'
DB = 'devilflow_bande'
QUERY = 'SELECT * FROM v_bandacittadiquartu_riepilogoannualepercepito_esterni where Anno = 2023'

def datatable(db:str, query:str):
    read = ReadDB(db=DB,query=QUERY)
    res = read.run()
    datatable = []
    datatable.append(list(res['data'][0].keys()))
    for r in res['data']:
        datatable.append(list(r.values()))

    return datatable

data = datatable(db=DB, query=QUERY)
table = Table(data)

table.setStyle(TableStyle([
    ('INNERGRID',(0,0), (-1,-1), 0.25, colors.black),
    ('BOX', (0,0), (-1,-1), 0.25, colors.black)
]))

#story = [
#    Paragraph("Riepilogo Annuo 2023 Esterno", getSampleStyleSheet()['Heading1']),
#    Spacer(1,1),
#    table
#]

c = Canvas('report.pdf')
c.drawImage(LOGO,100,710)
c.drawString(20,810,'Riepilogo 2023 Esterni')

#f = Frame(inch,inch, 6 * inch, 9 * inch)
#f.addFromList(story,c)
c.save()

from datetime import datetime
from typing import Any
from jobs import (
    ReadCsv,
    ReadFixedWidth
) 
from types_db import DataRow, TaskData
from feeds.tasks import MassiveInsert

FILEPATH = "C:\ScriptAdminRoot\Execute\main\Database\\banche.csv"
FIELDS = [
    "Codice",
    "Descrizione"
]
DB = "devilflow_main"
TABLE = "d_banca"

#FILEPATH = "C:\ScriptAdminRoot\Execute\main\Database\\fixedwidth.txt"
#FIELDS = {
#    "NAME": [0,24],
#    "STATE": [24,37],
#    "TELEPHONE": [37,48], 
#}

def readcsv(fields: dict, filepath:str, delimiter:str) -> TaskData:
    tt = datetime.now()
    tt = tt.strftime("%Y-%m-%dT%H:%M:%S+00:00")
    task_dati = {
        "data":[
            {
                "source_path":filepath,
                "timestamp": tt
            },
        ],    
    }
    read = ReadCsv(
        fields= fields,
        options={"delimiter": delimiter},
    )
    dati = read.run(task_dati["data"][0])
    return dati

def readfixedwidth(fields:dict, filepath: str) -> TaskData:
    task_dati = {
        "data":[
            {"path": filepath},
        ],
    }

    read = ReadFixedWidth(
        fields=fields,
        skip_lines=1,
    )
    dati = read.run(task_dati["data"][0])

    return dati

def ingest_no_meta(db: str, table: str, data:TaskData):
    ingest = MassiveInsert(
        db=db,
        table=table
    )

    ingest.run(data=data)

dati_csv = readcsv(fields=FIELDS,filepath= FILEPATH,delimiter=';')
ingest_no_meta(db=DB, table=TABLE, data=dati_csv)


'''ToDo.'''
#ingest = IngestFeed(
#    db=DB,
#    provider="fiori",
#    feed="",
#    scrap_tags=("alert",),
#)

#res = ingest.run(data=dati_csv)
from feeds.tasks import ReadDB
from jobs.fromsecret import get_dbload_conf
from types_db import TaskData
from jobs.files import WriteCsv
from pydrive.auth import GoogleAuth
from pydrive.drive import GoogleDrive
import os

TABLES = [
   #'D_Banda',
    #'D_NaturaFlusso', 'D_Comune', 'D_Provincia', 'D_Regione', 'D_Stato',
    #'D_RuoloBanda','D_RuoloContatto','D_SezioneRendiconto', 'D_SottoVoceRendiconto','D_VoceRendiconto',
    #'D_Strumento','D_TipoIndirizzo', 'S_VoceContabilita',
    #'T_Contatto','T_Esterni','T_FlussoCassa','T_Indirizzo','T_Persona',
    #'T_R_Banda_Indirizzo','T_Ricevute','T_Soci',
    'T_Servizi',    'T_R_Persona_Indirizzo'
]

def read_data(query:str, db:str) -> TaskData:
    extract= ReadDB(db=db, query=query)
    res = extract.run()
    return res

def write_csv(fields: list,
              filename:str,
              sourcepath:str,
              data:TaskData
) -> TaskData:    
    write = WriteCsv(
        fields= fields,
        filename=f"{sourcepath}/{filename}"
    )
    filewrite = write._write(data)
    files = []
    for row in filewrite["data"]:
        path = str(row["path"])
        files.append(path)
    return files

def upload_to_google_drive(file:str, gdrivefolder:str, drive:any):
    query = f"'{gdrivefolder}' in parents and trashed=False"
    file_list = drive.ListFile({'q': query}).GetList()
    try:
        for file1 in file_list:
            if file1['title'] == os.path.basename(file):
                file1.Delete()
    except:
        pass
    f = drive.CreateFile({'parents': [{'id':gdrivefolder}],
                      'title': os.path.basename(file)
                      })
    f.SetContentFile(file)
    f.Upload({'convert':True})

def process_loaddb_to_drive(gdrivefolder:str,
                             db:str,
                             query:str,
                             sourcepath:str,
                             fields:list,
                             filename:str,
                             drive:any
):
    data = read_data(db=db, query=query)
    file = write_csv(fields=fields, data=data,filename=filename,sourcepath=sourcepath)
    for f in file:
        upload_to_google_drive(file=f, gdrivefolder=gdrivefolder,drive=drive)


gauth = GoogleAuth()
gauth.LocalWebserverAuth()
drive = GoogleDrive(gauth) 

for t in TABLES:
    gdfolder, sourcepath, db, query, fields, filename = get_dbload_conf(t)

    process_loaddb_to_drive(
        gdrivefolder=gdfolder,
        sourcepath=sourcepath,
        db=db,
        query=query,
        fields=fields,
        filename=filename,
        drive=drive
    )
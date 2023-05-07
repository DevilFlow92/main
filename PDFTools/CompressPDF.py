import PyPDF2
import io, argparse, os

parser = argparse.ArgumentParser(description="Compress PDF")
parser.add_argument("-filepath",  action="store", help="Path to the original PDF. Use / instead of \\")
args = parser.parse_args()

def CompressPDF(filepath: str):
    
    # Apri il file PDF in modalità lettura
    with open(filepath, 'rb') as pdf_file:
        pdf_reader = PyPDF2.PdfReader(pdf_file)

        # Crea un oggetto PdfFileWriter
        pdf_writer = PyPDF2.PdfWriter()

        #Cicla tutte le pagine del file originale
        for n in range(len(pdf_reader.pages)):
            page = pdf_reader.pages[n]
            pdf_writer.add_page(page)

        output_stream = io.BytesIO()
        pdf_compressed_writer = PyPDF2.PdfWriter()
        pdf_writer.write(output_stream)
        compressed_pdf_reader = PyPDF2.PdfReader(output_stream)

        for n in range(len(compressed_pdf_reader.pages)):
            page = compressed_pdf_reader.pages[n]
            pdf_compressed_writer.add_page(page)

        workdir = os.path.dirname(filepath)
        filename, ext = os.path.basename(filepath).split('.',1)
        filename = f"{filename}_compresso"
        outputfilepath = f"{workdir}/{filename}.{ext}"

        with open(outputfilepath,'wb') as output_file:
            pdf_compressed_writer.write(output_file)
        
if __name__ == "__main__":
    CompressPDF(filepath=args.filepath)
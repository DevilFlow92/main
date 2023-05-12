import face_recognition
import argparse
from PIL import Image, ImageDraw
import matplotlib.pyplot as plt
import datetime

BOUNDING_BOX_COLOR = "blue"
TEXT_COLOR = "white"
IMAGE_PATH = "E:/Immagini/DeviFlow92/face_comparison"

parser = argparse.ArgumentParser(description="Recognize two faces")
parser.add_argument("--TwoImages", action="store_true", help="Comparison of two faces in two image files. Requires arguments im1, im2")
parser.add_argument("--OneImage", action="store_true", help="Comparison of two faces in one file image. Requires only im1 argument")
parser.add_argument(
    "-im1",
    action="store",
    help="Image path to process. Pass only image name. It has to be in path E:\Immagini\DeviFlow92\\face_comparison\images",
)
parser.add_argument(
    "-im2",
    action="store",
    help="Image path to comparize with im1. Pass only image name. It has to be in path E:\Immagini\DeviFlow92\\face_comparison\images",
)
parser.add_argument(
    "-name",
    action="store",
    default=None,
    help="Additional argument: person to identify.",
)

parser.add_argument("-m", 
    action="store",
    default="hog",
    choices=["hog", "cnn"],
    help="Which model to use for training: hog (CPU), cnn (GPU).",                        
)

args = parser.parse_args()


def _display_face(draw, bounding_box, name):
    top, right, bottom, left = bounding_box
    draw.rectangle(((left, top), (right, bottom)), outline=BOUNDING_BOX_COLOR)
    text_left, text_top, text_right, text_bottom = draw.textbbox(
        (left,bottom), name
    )
    draw.rectangle(
        ((text_left, text_top), (text_right, text_bottom)),
        fill="blue",
        outline="blue",
    )
    draw.text(
        (text_left, text_top),
        name,
        fill="white",
    )


def TwoImagesComparize(
        file1: str,
        file2: str,
        model: str = "hog",
        originalname: str = None,                       
):
    file1 = f"{IMAGE_PATH}/images/{file1}"
    file2 = f"{IMAGE_PATH}/images/{file2}"

    image1 = face_recognition.load_image_file(file1)
    image2 = face_recognition.load_image_file(file2)

    face_locations1 = face_recognition.face_locations(image1,model=model)
    face_locations2 = face_recognition.face_locations(image2,model=model)

    face_encodings1 = face_recognition.face_encodings(image1)[0]
    face_encodings2 = face_recognition.face_encodings(image2)[0]

    results = face_recognition.compare_faces(
        [face_encodings1],
        face_encodings2,
        #tolerance=0.55,
    )

    if results[0]:
        resume = "Le facce sono uguali"
        if originalname is None:
            originalname = "Person Matched"
        name = originalname
    else:
        resume = "Le facce sono diverse"
        if originalname is None:
            originalname = "Person NOT Matched"
        name = "No match"

    print(resume)

    pillow_image1 = Image.fromarray(image1)
    pillow_image2 = Image.fromarray(image2)
    draw1 = ImageDraw.Draw(pillow_image1)
    draw2 = ImageDraw.Draw(pillow_image2)

    for bounding_box, encoding in zip(face_locations1, face_encodings1):
        print(encoding)
        _display_face(draw1, bounding_box, name)

    for bounding_box, encoding in zip(face_locations2, face_encodings2):
        print(encoding)
        _display_face(draw2, bounding_box, name)

    del draw1, draw2

    fig = plt.figure(figsize=(10,7))
    plt.title(
        loc="center",
        label=resume,
    )
    plt.axis('off')
    r = 1
    c = 2

    fig.add_subplot(r,c,1)
    plt.imshow(pillow_image1)
    plt.axis('off')
    plt.title(file1)

    fig.add_subplot(r,c,2)
    plt.imshow(pillow_image2)
    plt.axis('off')
    plt.title(file2)    
    
    now = datetime.datetime.now()
    ct = now.strftime("%Y%m%d%H%M")
    plt.savefig(f'{IMAGE_PATH}/outputs/{ct}_{name}.png')
    #plt.show()

    
def OneImageComparize(
        image_location: str,
        model: str = "hog",
        originalname: str = None,
):
    image_location = f"{IMAGE_PATH}/images/{image_location}"

    input_image = face_recognition.load_image_file(image_location)

    input_face_locations = face_recognition.face_locations(
        input_image, model=model
    )
    input_face_encodings = face_recognition.face_encodings(input_image, input_face_locations)

    face_encodings1 = input_face_encodings[0]
    face_encodings2 = input_face_encodings[1]

    results = face_recognition.compare_faces(
        [face_encodings1],
        face_encodings2,
        #tolerance=0.55,
    )
    if results[0]:
        resume = "Identificazione avvenuta con successo"
        if originalname is None:
            originalname = "Person matched"
        name = originalname
    else:
        resume = "Identificazione da verifcare. Le facce sono diverse"
        if originalname is None:
            originalname = "Person NOT Matched"
        name = "No match"

    print(resume)
    
    pillow_image = Image.fromarray(input_image)
    draw = ImageDraw.Draw(pillow_image)

    for bounding_box, encoding in zip(
        input_face_locations, input_face_encodings
    ):
        print(encoding)
        _display_face(draw,bounding_box,name)

    del draw
    now = datetime.datetime.now()
    ct = now.strftime("%Y%m%d%H%M")
    pillow_image.save(f'{IMAGE_PATH}/outputs/{ct}_{originalname}.png')
    #pillow_image.show()
    

if __name__ == "__main__":
    if args.TwoImages:
        TwoImagesComparize(file1=args.im1, file2=args.im2, originalname=args.name)
    if args.OneImage:
        OneImageComparize(image_location=args.im1, model=args.m, originalname=args.name)


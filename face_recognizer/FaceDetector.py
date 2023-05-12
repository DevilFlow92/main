from pathlib import Path
import face_recognition
import pickle
from collections import Counter
from PIL import Image, ImageDraw
import argparse
import time

DEFAULT_ENCODINGS_PATH = Path("output/encodings.pkl")
IMAGE_PATH = "E:/Immagini/DevilFlow92/face_recognizer"

BUONDING_BOX_COLOR = "blue"
TEXT_COLOR = "white"

parser = argparse.ArgumentParser(description="Recognize faces in an image")

parser.add_argument("--train", action="store_true", help="Train on input data")
parser.add_argument("--validate", action="store_true", help="Validate trained model")
parser.add_argument("--test", action="store_true", help="Test the model with an unknown image")
parser.add_argument("-m", 
    action="store",
    default="hog",
    choices=["hog", "cnn"],
    help="Which model to use for training: hog (CPU), cnn (GPU)",                        
)
parser.add_argument("-f",
    action="store",
    help="Path to an image with an unknown face"

)

args = parser.parse_args()

Path(f"{IMAGE_PATH}/training").mkdir(exist_ok=True)
Path("output").mkdir(exist_ok=True)
Path(f"{IMAGE_PATH}/validation").mkdir(exist_ok=True)


#HOG (histogram of oriented gradients) -> https://pyimagesearch.com/2014/11/10/histogram-oriented-gradients-object-detection/
#CNN (convolutional neural network) -> https://towardsdatascience.com/a-comprehensive-guide-to-convolutional-neural-networks-the-eli5-way-3bd2b1164a53


def encode_known_faces(
        model: str= "hog", encodings_location: Path = DEFAULT_ENCODINGS_PATH
) -> None:
    ''' genero un file pkl che sarebbe il modello di riconoscimento facciale
    per allenare il modello, metto altre immagini sulla sottocartella training
    ed eseguo la funzione
    '''
    names =[]
    encodings = []
    for filepath in Path(f"{IMAGE_PATH}/training").glob("*/*"):
        name = filepath.parent.name
        image = face_recognition.load_image_file(filepath)

        # To detect the locations of faces in each image.
        # The function returns a list of four-element tuples, one tuple for each detected face.
        # The four elements per tuple provide the four coordinates of a box that could surround the detected face.
        # Such a box is also known as a bounding box.
        face_locations = face_recognition.face_locations(image, model=model)
        
        # To generate encodings for the detected faces in an image.
        # Remember that an encoding is a numeric representation of facial features that’s used to match similar faces by their features.
        face_encodings = face_recognition.face_encodings(image, face_locations)

        for encoding in face_encodings:
            # here i add the names and their encodings to separate lists
            names.append(name)
            encodings.append(encoding)
    
    name_encodings = {"names": names, "encodings": encodings}
    with encodings_location.open(mode="wb") as f:
        pickle.dump(name_encodings, f)


def _recognize_face(unknown_encoding, loaded_encodings):
    boolean_matches = face_recognition.compare_faces(
        loaded_encodings["encodings"], unknown_encoding
    )
    # recognize each face in given images, then return the matches
    votes = Counter(
        name
        for match, name in zip(boolean_matches, loaded_encodings["names"])
        if match
    )
    if votes:
        return votes.most_common(1)[0][0]

def _display_face(draw, bounding_box, name):
    top, right, bottom, left = bounding_box
    draw.rectangle(((left,top), (right,bottom)), outline=BUONDING_BOX_COLOR)
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

def recognize_faces(
        image_location: str,
        model: str = "hog",
        encodings_location: Path = DEFAULT_ENCODINGS_PATH,
) -> None:
    # Function to open and load the saved face encodings using pickle and then load the image in which
    # you want to recognize faces.

    with encodings_location.open(mode="rb") as f:
        loaded_encodings = pickle.load(f)
    
    input_image = face_recognition.load_image_file(image_location)

    input_face_locations = face_recognition.face_locations(
        input_image, model= model
    )
    input_face_encodings = face_recognition.face_encodings(
        input_image, input_face_locations
    )

    pillow_image = Image.fromarray(input_image)
    draw = ImageDraw.Draw(pillow_image)

    for bounding_box, unknown_encoding in zip(
        input_face_locations, input_face_encodings
    ):
        name = _recognize_face(unknown_encoding, loaded_encodings)
        if not name:
            name = "Unknown"
        #print(name,bounding_box)
        _display_face(draw, bounding_box, name)

    del draw
    pillow_image.show()


def validate(model: str= "hog"):
    for filepath in Path(f"{IMAGE_PATH}/validation").rglob("*"):
        if filepath.is_file():
            recognize_faces(
                image_location=str(filepath.absolute()),
                model=model,
            )

#encode_known_faces()
#recognize_faces("unknown.jpg")
#validate()

if __name__ == "__main__":
    if args.train:
        encode_known_faces(model=args.m)
    if args.validate:
        validate(model=args.m)
    if args.test:
        recognize_faces(image_location=args.f, model=args.m)
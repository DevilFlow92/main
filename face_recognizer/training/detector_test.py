from pathlib import Path
import face_recognition
import pickle


DEFAULT_ENCODINGS_PATH = Path("output/encodings.pkl")

Path("training").mkdir(exist_ok=True)
Path("output").mkdir(exist_ok=True)
Path("validation").mkdir(exist_ok=True)

#HOG (histogram of oriented gradients) -> https://pyimagesearch.com/2014/11/10/histogram-oriented-gradients-object-detection/
#CNN (convolutional neural network) -> https://towardsdatascience.com/a-comprehensive-guide-to-convolutional-neural-networks-the-eli5-way-3bd2b1164a53

def encode_known_faces(
        model: str= "hog", encodings_location: Path = DEFAULT_ENCODINGS_PATH
) -> None:
    names =[]
    encodings = []
    for filepath in Path("training").glob("*/*"):
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


encode_known_faces()
        

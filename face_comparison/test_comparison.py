import face_recognition
import argparse
from PIL import Image
import matplotlib.pyplot as plt

parser = argparse.ArgumentParser(description="Recognize two faces")
parser.add_argument("--TwoImages", action="store_true", help="Comparison of two faces in two image files. Requires arguments im1, im2")
parser.add_argument("--OneImage", action="store_true", help="Comparison of two faces in one file image. Requires only im1 argument")
parser.add_argument(
    "-im1",
    action="store",
    help="Image path to process. Use / instead of \\",
)
parser.add_argument(
    "-im2",
    action="store",
    help="Image path to comparize with im1. Use / instead of \\",
)
args = parser.parse_args()


def TwoImagesComparize(file1, file2):

    image1 = face_recognition.load_image_file(file1)
    image2 = face_recognition.load_image_file(file2)

    face_encodings1 = face_recognition.face_encodings(image1)[0]
    face_encodings2 = face_recognition.face_encodings(image2)[0]

    results = face_recognition.compare_faces(
        [face_encodings1],
        face_encodings2,
        #tolerance=0.55,
    )

    if results[0]:
        resume = "Le facce sono uguali"
    else:
        resume = "Le facce sono diverse"

    print(resume)

    pillow_image1 = Image.fromarray(image1)
    pillow_image2 = Image.fromarray(image2)    
    ax1 = plt.subplot2grid((10,8), (0,0), rowspan=5, colspan=4)
    ax2 = plt.subplot2grid((10,8), (0,4), rowspan=5, colspan=4)
    ax1.imshow(pillow_image1)
    ax2.imshow(pillow_image2)
    
    plt.title(
        loc="center",
        label=resume,
    )
    plt.show()
    
def OneImageComparize():
    print("To Do.")


if __name__ == "__main__":
    if args.TwoImages:
        TwoImagesComparize(file1=args.im1, file2=args.im2)
    if args.OneImage:
        OneImageComparize()


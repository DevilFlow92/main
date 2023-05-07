import matplotlib
import numpy as np
from PIL import Image

i = Image.open('images/dot.png')
iar = np.asarray(i)

print(iar)

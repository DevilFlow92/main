# Tutorial
https://pythonprogramming.net/image-recognition-python/

# Introdution ad dependencies
Here, our goal is to begin to use machine learning, in the form of pattern recognition, to teach our program what text looks like. In this case, we'll use numbers, but this could translate to all letters of the alphabet, words, faces, really anything at all. The more complex the image, the more complex the code will need to become. When it comes to letters and characters, it is relatively simplistic, however.

How is it done? Just like any problem, especially in programming, we need to just break it down into steps, and the problem will become easily solved. Let's break it down!

First, you are going to need some sample documents to help with this series, you can get the sample images here.

From there, extract the zip folder and move the "images" directory to wherever you're writing this script. Within it, you should have an "images" directory. Within that, you have some simple images that we'll be using and then you have a bunch of example numbers within the numbers directory.

Once you have that, you're going to need the Python programming language. This specific series was created using Python 2.7. You can go through this with Python 3, though there may be some minor differences.

You will also need Matplotlib, NumPy and PIL or Pillow. You can follow the video for installation, or you can also use pip install. At the time of my video, pip install wasn't really a method I would recommend. With any newer version of Python 2 or 3, you will get pip, and pip support on almost all packages is there now.

Don't know what pip is or how to install modules?
Pip is probably the easiest way to install packages Once you install Python, you should be able to open your command prompt, like cmd.exe on windows, or bash on linux, and type:

pip install numpy
pip install matplotlib
pip install Pillow


# Understanding Pixel arrays
For this, we use PIL or Pillow, depending on what you were able to install (depending on your Python bit-version).

if you are on 32 bit os
import Image

64 bit with pillow:
from PIL import Image
import numpy as np

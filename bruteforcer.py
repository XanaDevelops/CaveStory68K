#https://github.com/mon/bad_apple_virus/blob/master/bad%20apple.py#L169

from itertools import cycle, product
import os
import json
from typing import Optional
from PIL import Image, ImageDraw
import cv2
from tqdm import tqdm
import numpy as np

import time

inp = "【東方】Bad Apple!! ＰＶ【影絵】 [FtutLA63Cp8].webm"
out = "apple_frames"
max_width = 283
threshold = 255 *0.5

black   = (0,0,0,0)

def frame_to_boxes(im: Image, name) -> list:
    w, h = im.size
    ratio = w / h

    # greyscale
    #im = im.convert("L")
    # resize
    #im = im.resize((max_width, int(max_width / ratio)))
    #print([im.load()[x,y] for x,y in product(range(im.width), range(im.height))])
    #print(type(im.load()[0,0]))
    # threshold
    #im = im.point(lambda p: 255 if p > threshold else 0)
    # mono
    #im = im.convert("1")

    # find largest region via brute force
    # tqdm.write(f'{im.width=} {im.height=}')
    pixels = im.load()
    print(f"SIZE {im.size}")
    visited = np.zeros(im.size, dtype=bool)

    # visualisation
    boxes = []
    colors = []
    sizes = []

    work = im.copy().convert("RGB")
    draw = ImageDraw.Draw(work)

    
    try: 
        while False in visited:
            color:tuple = None
            largest: Optional[tuple[int, int, int, int]] = None  # x, y, width, height

            for x, y in product(range(im.width), range(im.height)):
                if visited[x, y] or pixels[x, y] == black:
                    visited[x, y] = True
                    continue

                sublargest: Optional[tuple[int, int]] = None
                widest = im.width - x  # optimise
                color:tuple = pixels[x,y]

                if widest == 0:
                    continue

                # row by row
                for h in range(im.height - y):
                    # search until black pixel
                    for w in range(widest + 1):
                        if (
                            (w == widest)
                            or visited[x + w, y + h]
                            or pixels[x + w, y + h] == black
                            or pixels[x+w, y+h] != color
                        ):
                            break

                    # tqdm.write(f'tapped out {x} {y} {w} {h} {widest}')

                    widest = min(widest, w)
                    if sublargest is None or (sublargest[0] * sublargest[1]) < (
                        (w) * (h + 1)
                    ):
                        sublargest = [w, h + 1]
                        

                if largest is None or (largest[2] * largest[3]) < (
                    sublargest[0] * sublargest[1]
                ):
                    largest = [x, y, *sublargest]
                    color:tuple = pixels[x,y]

                # break # debug

            # tqdm.write(f'{largest=}')

            # Generally only occurs when the entire frame is black
            if largest is None:
                break

            visited[
                largest[0] : largest[0] + largest[2], largest[1] : largest[1] + largest[3]
            ] = True

            

            # [(x0, y0), (x1, y1)] from [x0, y0, w, h], where the bounding box is inclusive
            box = [
                (largest[0], largest[1]),
                (largest[0] + largest[2] - 1, largest[1] + largest[3] - 1),
            ]

            boxes.append([largest, pixels[box[0][0],box[0][1]]])
            colors.append(pixels[box[0][0],box[0][1]])
            print(pixels[box[0][0],box[0][1]])
            sizes.append(largest)
            #
            draw.rectangle(box, fill=pixels[box[0][0],box[0][1]])
            #draw.rectangle(box, fill=next(fills))
            
            #print(box)

            #work.show() # debug
                #work.save(os.path.join(out, f"{name}.png"))
                #time.sleep(0.5)
                #print(box)
            # exit()

            # break # debug
    except KeyboardInterrupt:
        pass
    
    tqdm.write(f"{len(boxes)=}")
    #with open("log.txt", "w") as log:
        #log.write("\n".join([str(x)+str(y) for x,y in boxes]))
    # im.show()
    #work.show()

    #work.save(os.path.join(out, f"{name}.png"))

    return [sizes, colors]


'''image_counter = 0

cap = cv2.VideoCapture(inp)
prog = tqdm(total=6570)
all_boxes = []

try:
    while cap.isOpened():
        ret, cv2_im = cap.read()
        if ret:
            converted = cv2.cvtColor(cv2_im, cv2.COLOR_BGR2RGB)

            pil_im = Image.fromarray(converted)
            all_boxes.append(frame_to_boxes(pil_im, f"{image_counter}"))
            image_counter += 1
            prog.update()
        elif not ret:
            break

    cap.release()
finally:
    with open("boxes.json", "w") as f:
        json.dump(all_boxes, f)'''
if __name__ == "__main__":
    #BMP/Tiles/PrtCave/PrtCave_2.png
    # BMP/titlefix.bmp
    im = Image.open('BMP/Tiles/PrtCave/PrtCave_1.png')
    frame_to_boxes(im, 'test')
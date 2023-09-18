#import simple_inkscape_scripting as sis
#from simpinkscr.simple_inkscape_scripting import *

#from simple_inkscape_scripting import all_shapes
import sys, os, subprocess
from PIL import Image
import numpy as np


class Conversor():

    dirSprites = "./svg/"
    dirMapas   = "./mapas/"

    pathSprites = "./data/sprites.x68"
    pathMaps    = "./data/maps.x68"

    def __init__(self):
        self.PrintMenu()

    def PrintMenu(self):
        print("--- Bienvenido al conversor de svg/bmp ---\n")
        salir = False
        while(not salir):
            print("Selecciona una opción:")
            print("     [1] ConvertAll")
            print("     [2] ConvertSprites (SVG)")
            print("     [3] ConvertMapas (BMP)")
            print("     [4] ConvertSingle")
            print("     [5] Convertir Coords")                    
            print("     [0] Exit")

            r = input("?: ")
            if(r.isdecimal()):
                r=int(r)
                match r:
                    case 1:
                        self.ConvertAll()
                    case 2:
                        self.ConvertAllSprites()
                    case 3:
                        self.ConvertAllMapas()
                    case 4:
                        self.ConvertSpriteSVG(input("Path: "))
                        
                    case 0:
                        salir = True
                    case _:
                        print("Opcion no valida", file=sys.stderr)

    def ConvertAll(self):
        pass

    def ConvertAllSprites(self):
        print("\nConvirtiendo Sprites (SVG)")
        with open(self.pathSprites, "w") as fsprite:
            fsprite.writelines("*-----------------------------------------------------------\n")
            fsprite.writelines("* Title      : SpriteData\n")
            fsprite.writelines("* Written by : Xana\n")
            fsprite.writelines("* Date       :\n")
            fsprite.writelines("* Description: Generado automaticamente por pyconverterU.py\n")
            fsprite.writelines("*-----------------------------------------------------------\n")
            fsprite.writelines("ColorNULL:\n\tDC.L -1\nSizeNULL:\n\tDC.W 0,0,0,0\n\nNULL: DC.L ColorNULL, SizeNULL\n\n")
        for x in os.listdir(self.dirSprites):
            if(".svg" in x):
                self.ConvertSpriteSVG(self.dirSprites+x)

            #fsprite.writelines(f"\nSPRITEV DC.L {', '.join(names)}\n")
        with open(self.pathSprites, "+a") as fsprite:
            fsprite.writelines("\n\n\n*~Font name~Courier New~\n")
            fsprite.writelines("*~Font size~10~\n")
            fsprite.writelines("*~Tab type~1~\n")
            fsprite.writelines("*~Tab size~4~\n")

    def ConvertSpriteSVG(self, path:str, verb:bool = False) -> list:

        #os.popen(f"python .\simpinkscr\simple_inkscape_scripting.py --py-source=conversor.py .\sprites\dibujo.svg")
        
        #print(retText)

        subprocess.run(f"python .\simpinkscr\simple_inkscape_scripting.py --py-source=conversor.py {path} {self.pathSprites} {path}".split())
        

    def ConvertAllMapas(self):
        print("\nConvirtiendo Mapas")
        with open(self.pathMaps, "w") as fmap:
            fmap.writelines("*-----------------------------------------------------------\n")
            fmap.writelines("* Title      : MapData\n")
            fmap.writelines("* Written by : Xana\n")
            fmap.writelines("* Date       :\n")
            fmap.writelines("* Description: Generado automaticamente por pyconverterU.py\n")
            fmap.writelines("*-----------------------------------------------------------\n")
            
            for x in os.listdir(self.dirMapas):
                if x.endswith(".bmp"):
                    data, name, x,y = self.ConvertMapa(self.dirMapas+x)
                    fmap.writelines(data+"\n")
                    fmap.writelines(f"{name} DC.L {name}_DATA\n\t\t\tDC.W {x}, {y}\n")


            fmap.writelines("\n\n\n*~Font name~Courier New~\n")
            fmap.writelines("*~Font size~10~\n")
            fmap.writelines("*~Tab type~1~\n")
            fmap.writelines("*~Tab size~4~\n")

    def ConvertMapa(self, path:str, verb:bool=False):
        img = Image.open(path)
        bmpName = path.split("/")[-1].split(".")[0].upper()
        #print(bmpName,"\n", np.array(img))
        pix = np.array(img).reshape(img.height, img.width, 4).tolist()

        retText = bmpName+"_data:\n"
        auxText = []
        for y in range(img.height):
            l = 0
            for x in range(img.width):
                clr = self.ToBGR(pix[y][x])
                if clr != "$00000000":
                    auxText.append(clr)

            retText += self.truncateText(auxText, "DC.B",21)
            auxText.clear()

        with open("colormap.txt") as clrMap:
            l = clrMap.readline()

            while(l != ""):
                l=l.replace("\n","").split(",")

                
                if(len(l[1])==1):
                    retText=retText.replace(l[0], " "+str(int(l[1])*4))
                else:
                    retText=retText.replace(l[0], str(int(l[1])*4))
                #print(x)
                l = clrMap.readline()

        if(retText.count("$")>0):
            print("Se ha encontrado colores fuera de la lista")
            while(retText.count("$")>0):
                i = retText.index("$")
                color = retText[i:i+9]
                n=input(color+" a num? ")
                retText=retText.replace(color, str(n))

        #print(retText)
        return [retText, bmpName, img.width, img.height]
    
    def ToBGR(self, x:list):
        r,g,b,a=x
        #print("ALFA",a) if a!=255 else None
        r=hex(r)[2:].upper().zfill(2)
        g=hex(g)[2:].upper().zfill(2)
        b=hex(b)[2:].upper().zfill(2)
        a=hex(a)[2:].upper().zfill(2)
        ret = a+b+g+r
        if ret=="00FFFFFF" or a=="00":
            ret="00000000"
            a="00"

        if a!="FF" and a!="00":
            print("Alpha erroneo, no 00 FF", file=sys.stderr)
            ret="00000000"
        return "$"+ret
    
    def truncateText(self, text:list, dataSize:str, tam:int = 16 ) -> str:
        if len(text)==0:
            return ""
        if len(text)<tam:
            return f"\t{dataSize} {', '.join(text)}\n"
        aux = 0
        retText =""
        while(aux+tam<len(text)):
            retText+= f"\t{dataSize} {', '.join(text[aux:aux+tam])}\n"
            aux+=tam
        retText+= f"\t{dataSize} {', '.join(text[aux:])}\n"

        return retText

Conversor()
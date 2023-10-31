#import simple_inkscape_scripting as sis
#from simpinkscr.simple_inkscape_scripting import *

#from simple_inkscape_scripting import all_shapes
from io import TextIOWrapper
import sys, os, subprocess
from PIL import Image
import numpy as np


class Conversor():

    dirSprites  = "./svg/"
    dirSprBMP   = "./BMP/"
    dirMapas    = "./mapas/"
    dirSFX      = "./SFX/"
    dirBGM      = "./BGM/"

    pathSprites = "./data/sprites.x68"
    pathMaps    = "./data/maps.x68"
    pathSI      = "./data/sounds.x68"

    def __init__(self):
        self.PrintMenu()

    def PrintMenu(self):
        print("--- Bienvenido al conversor de svg/bmp ---\n")
        salir = False
        while(not salir):
            print("Selecciona una opción:")
            print("     [1] ConvertAll")
            print("     [2] ConvertSprites (SVG)+(BMP)")
            print("     [3] ConvertMapas (BMP)")
            print("     [4] ConvertSingle")
            print("     [5] Convertir Coords")  
            print("     [6] Importar sonidos")                  
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
                    case 6:
                        self.SoundImport()
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
            fsprite.flush()
            os.fsync(fsprite)
        self.RecursiveConverter(self.dirSprites)
        

            #fsprite.writelines(f"\nSPRITEV DC.L {', '.join(names)}\n")
        with open(self.pathSprites, "+a") as fsprite:
            for x in os.listdir(self.dirSprBMP):
                if(".bmp" in x):
                    fsprite.writelines(self.ConvertSprite(self.dirSprBMP+"/"+x)[0])

            fsprite.writelines("\n\n\n*~Font name~Courier New~\n")
            fsprite.writelines("*~Font size~10~\n")
            fsprite.writelines("*~Tab type~1~\n")
            fsprite.writelines("*~Tab size~4~\n")

    def RecursiveConverter(self, path:str):
        for x in os.listdir(path):
            #print("###############\n############")
            ###print("COMPROBANDO",path+"/"+x,os.path.isdir(path+"/"+x))
            #print("###############\n############")
            if(os.path.isdir(path+"/"+x)):
                self.RecursiveConverter(path+"/"+x)
            if(".svg" in x):
                self.ConvertSpriteSVG(path+"/"+x)

    def ConvertSpriteSVG(self, path:str, verb:bool = False) -> list:

        #os.popen(f"python .\simpinkscr\simple_inkscape_scripting.py --py-source=conversor.py .\sprites\dibujo.svg")
        
        #print(retText)

        subprocess.run(f"python .\simpinkscr\simple_inkscape_scripting.py --py-source=conversor.py {path} {self.pathSprites} {path}".split())
        
    def ConvertSprite(self, path:str, verb:bool = False) -> list:
        img = Image.open(path)
        bmpName = path.split("/")[-1].split(".")[0].upper()

        pix = np.array(img).reshape(img.height, img.width, 4).tolist()

        colorText = f"Color{bmpName}:\n"
        sizeText = f"Size{bmpName}:\n"

        colors = []
        sizes = []
        for y in range(img.height):
            actualColor =self.ToBGR(pix[y][0])
            l = 0
            for x in range(img.width):
                clr = self.ToBGR(pix[y][x])
                if actualColor!=clr:
                    if actualColor != "$00000000":
                        actualColor = actualColor.replace("$FF","$00")
                        colors.append(actualColor)
                        [sizes.append(z) for z in[l,2*y, 2*x-1,2*y+1]]
                    l=2*x
                    actualColor = clr

            print("y:",y,sizes,"l:",l, file=sys.stdout)
            
            if l<img.width*2:
                if actualColor != "$00000000":
                    actualColor = actualColor.replace("$FF","$00")
                    colors.append(actualColor)
                    [sizes.append(z) for z in[l,2*y, img.width*2-1,2*y+1]]


            #colorText += "\tDC.L "+", ".join(colors)+"\n"
            colorText += self.truncateText(colors, "DC.L")
            sizesT = [str(z) for z in sizes]
            sizeText  += self.truncateText(sizesT, "DC.W")
            colors.clear()
            sizes.clear()

        retText = f"{colorText}\tDC.L -1\n{sizeText}\n\n{bmpName} DC.L Color{bmpName}, Size{bmpName}\n"
        #print(retText)
        return [retText, bmpName]

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
    
    def SoundImport(self):
        print("\nImportando Canciones y SFX")
        with open(self.pathSI, "+w") as fsound:
            fsound.writelines("*-----------------------------------------------------------\n")
            fsound.writelines("* Title      : SoundData\n")
            fsound.writelines("* Written by : Xana\n")
            fsound.writelines("* Date       :\n")
            fsound.writelines("* Description: Generado automaticamente por conversor-script.py\n")
            fsound.writelines("*-----------------------------------------------------------\n")

            self._soundImport(self.dirSFX, "SFX", fsound)
            self._soundImport(self.dirBGM, "BGM", fsound)


            fsound.writelines("\n\n\n*~Font name~Courier New~\n")
            fsound.writelines("*~Font size~10~\n")
            fsound.writelines("*~Tab type~1~\n")
            fsound.writelines("*~Tab size~4~\n")
                    
    def _soundImport(self, path:str, name:str, file:TextIOWrapper) -> None:
        snd_v = []
        snds  = []
        n=0
        for x in os.listdir(path):
            if x.endswith(".wav"):
                vName = self.SectorName(x.upper())
                snd_v.append(vName)
                snds.append(self.SongNamer(x, path, vName, n))
                n+=1
        file.write(f"NUM{name}\tEQU {len(snd_v)}\n")
        file.write(f"{name}_V\n")
        file.writelines(self.truncateText(snd_v, "DC.L"))
        file.writelines(snds)
        file.write("\tDS.W 0\n\n")

    def SongNamer(self, x:str, path:str, vName:str, n:int) -> str:
        return f"{vName}\tDC.B '{path}{x}',0\t;{n}\n"
    
    def SectorName(self, x:str) -> str:
        for y in ["_", " ",".WAV","(", ")", "'","'","!", "NTERNAL", "ERCUSSION"]:
            x=x.replace(y, "") 
        return f".{x}"

    
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
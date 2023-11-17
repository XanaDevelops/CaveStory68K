#import simple_inkscape_scripting as sis
#from simpinkscr.simple_inkscape_scripting import *

#from simple_inkscape_scripting import all_shapes
from io import TextIOWrapper
import sys, os, subprocess, shutil
from PIL import Image
import numpy as np
import tmx
from split_image import split_image
from bruteforcer import frame_to_boxes


class Conversor():

    dirSprites  = "./svg/"
    dirSprBMP   = "./BMP/"
    dirMapas    = "./mapas/"
    dirSFX      = "./SFX/"
    dirBGM      = "./BGM/"
    dirTiled    = "./Tiled/"
    dirTiles    = "./BMP/tilemaps/"
    dirOutTiles = "./BMP/tiles/"

    pathSprites = "./data/sprites.x68"
    pathTiles   = "./data/tiles.x68"
    pathMaps    = "./data/newMaps.x68"
    pathEntity  = "./data/newEntsData.x68"
    pathSI      = "./data/sounds.x68"
    pathSpriteV = "./data/SPRITEVECTOR.x68"

    tilePixSize = 16
    tileMult    = 4

    def __init__(self):
        self.PrintMenu()

    def PrintMenu(self):
        print("--- Bienvenido al conversor de svg/bmp ---\n")
        salir = False
        while(not salir):
            print("Selecciona una opción:")
            print("     [1] ConvertAll")
            print("     [2] ConvertSprites (SVG)+(BMP)")
            print("     [3] ConvertMapas (TMX)")
            print("     [4] Convert TileMaps")
            print("     [4] ConvertSingle") 
            print("     [5] Importar sonidos")                  
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
                        self.ConvertAllMapsTmx()
                    case 4:
                        self.ConvertAllTileMaps()
                    case 5:
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
                    fsprite.writelines(self.ConvertSpriteOld(self.dirSprBMP+"/"+x)[0])

            fsprite.writelines("\n\n\n*~Font name~Courier New~\n")
            fsprite.writelines("*~Font size~10~\n")
            fsprite.writelines("*~Tab type~1~\n")
            fsprite.writelines("*~Tab size~4~\n")

    def RecursiveConverter(self, path:str):
        for x in os.listdir(path):
            #print("###############\n############")
            ###print("COMPROBANDO",path+"/"+x,os.path.isdir(path+"/"+x))
            #print("###############\n############")
            #input(path+x)
            if(os.path.isdir(path+x)):
                self.RecursiveConverter(path+x+"/")
            if(".svg" in x):
                self.ConvertSpriteSVG(path+"/"+x)
  

    def ConvertSpriteSVG(self, path:str, verb:bool = False) -> list:
        #os.popen(f"python .\simpinkscr\simple_inkscape_scripting.py --py-source=conversor.py .\sprites\dibujo.svg")
        #print(retText)
        subprocess.run(f"python .\simpinkscr\simple_inkscape_scripting.py --py-source=conversor.py {path} {self.pathSprites} {path}".split())
        
    def ConvertSpriteBForce(self, path:str, verb:bool = False) -> list:
        img = Image.open(path)
        bmpName = path.split("/")[-1].split(".")[0].upper()
        print(path)
        

        colorText = f".Color:\n"
        sizeText = f".Size:\n"

        sizes, _colors = frame_to_boxes(img, None)
        for i in range(len(sizes)):
            sizes[i]*=self.tileMult
            if(i%4>=2):
                sizes[i]-=1
        print(f"SIZES: {sizes}")
        print(f"COLORS {_colors}")
        colors=[]
        for x in _colors:
            colors.append(self.ToBGR(x))

        #colorText += "\tDC.L "+", ".join(colors)+"\n"
        colorText += self.truncateText(colors, "DC.L")
        sizesT = [str(z) for z in sizes]
        sizeText  += self.truncateText(sizesT, "DC.W")

        retText = f"\n{bmpName} DC.L .Color, .Size\n{colorText}\tDC.L -1\n{sizeText}\n\n"
        #print(retText)
        return [retText, bmpName]
    
    def ConvertSpriteOld(self, path:str, verb:bool = False) -> list:
        img = Image.open(path)
        bmpName = path.split("/")[-1].split(".")[0].upper()
        print(path)
        pix = np.array(img).reshape(img.height, img.width, 4).tolist()

        colorText = f".Color:\n"
        sizeText = f".Size:\n"

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

        retText = f"\n{bmpName} DC.L .Color, .Size\n{colorText}\tDC.L -1\n{sizeText}\n\n"
        #print(retText)
        return [retText, bmpName]

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

    def ConvertAllMapsBMP(self):
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

    def ConvertAllMapsTmx(self):
        print("\nConvirtiendo Mapas Tmx")
        with open(self.pathMaps, "w") as fmap:
            with open(self.pathEntity, "w") as fent:
                fmap.writelines("*-----------------------------------------------------------\n")
                fmap.writelines("* Title      : MapData\n")
                fmap.writelines("* Written by : Xana\n")
                fmap.writelines("* Date       :\n")
                fmap.writelines("* Description: Generado automaticamente por conversor-script.py\n")
                fmap.writelines("*-----------------------------------------------------------\n")

                fent.writelines("*-----------------------------------------------------------\n")
                fent.writelines("* Title      : EntityData\n")
                fent.writelines("* Written by : Xana\n")
                fent.writelines("* Date       :\n")
                fent.writelines("* Description: Generado automaticamente por conversor-script.py\n")
                fent.writelines("*-----------------------------------------------------------\n")

                names  = []
                mdata  = []
                edata  = []

                for x in os.listdir(self.dirTiled):
                    if x.endswith(".tmx"):
                        fname, w,h, tData, oData = self.ConvertMapaTiled(self.dirTiled+x)
                        #fmap.writelines(f"{fname} DC.L .{fname}_DATA\n\t\tDC.W {w}, {h}\n")
                        #fmap.writelines(f".{fname}_DATA:\n{tData}\n")
                        names.append(fname)
                        mdata.append(f".{fname} DC.L .{fname}_DATA\n\t\tDC.W {w}, {h}\n.{fname}_DATA:\n{tData}\n")
                        edata.append(f"{oData}\n")
                
                fmap.writelines(f"MAPS\tDC.L {', '.join([f'.{x}' for x in names])}\n")
                fmap.writelines("\n".join(mdata))
                fent.writelines(f"ENTINSTDATA\tDC.L {', '.join([f'.{x}' for x in names])}\n")
                fent.writelines("\n".join(edata))

    def ConvertMapaTiled(self, path:str) -> list:
        tmxF = tmx.TileMap.load(path)
        #importante orden dentro de Tiled
        tileLayer, objLayer = tmxF.layers

        tmxName = path.split("/")[-1].split(".")[0].upper()
        tileData = ""
        objData  = "."+tmxName+"\n"

        w,h = [tmxF.width, tmxF.height]
        for y in range(h):
            auxTile = []
            for x in range(w):
                auxTile.append(str(tileLayer.tiles[x+y*w].gid))
            tileData += f"\tDC.W {','.join(auxTile)}\n"

        for obj in objLayer.objects:
            objWSize = 3
            objName = obj.name.upper()
            objProp = ""
            for prop in obj.properties:
                mulu = 1
                if "_M_" in prop.name: #solo en int
                    mulu=4
                if "W" in prop.name:
                    objWSize+=1
                    objProp+=f"\t\t\tDC.W {prop.value*mulu}\n"
                if "L" in prop.name:
                    objWSize+=2
                    if type(prop.value)==str:
                        objProp+=f"\t\t\tDC.L {prop.value*mulu}>>16|{prop.value*mulu}<<16\n"
                    else:
                        objProp+=f"\t\t\tDC.L {prop.value*mulu}\n"
            objData += f"\t\tDC.W {objWSize}\n" 
            objData += objProp
            # pos*4, restar 16 a y por tiled
            objData += f"\t\t\tDC.L {self.ToHexXY(obj.x*4, (obj.y-16)*4)}, {objName}>>16|{objName}<<16\n"
        
        objData+="\t\tDC.W -1"
        return tmxName, w,h, tileData, objData
    
    def ConvertAllTileMaps(self):
        with open(self.pathSpriteV, "w") as fSV:
            with open(self.pathTiles, "w") as fTile:
                maxN:int = 0
                tilesD:dict = dict()
                fSV.writelines("*-----------------------------------------------------------\n")
                fSV.writelines("* Title      : SpriteVector\n")
                fSV.writelines("* Written by : Xana\n")
                fSV.writelines("* Date       :\n")
                fSV.writelines("* Description: Generado automaticamente por conversor-script.py\n")
                fSV.writelines("*-----------------------------------------------------------\n")

                fTile.writelines("*-----------------------------------------------------------\n")
                fTile.writelines("* Title      : Tiles\n")
                fTile.writelines("* Written by : Xana\n")
                fTile.writelines("* Date       :\n")
                fTile.writelines("* Description: Generado automaticamente por conversor-script.py\n")
                fTile.writelines("*-----------------------------------------------------------\n")


                for x in os.listdir(self.dirTiles):
                    # x es tilemap, formato png
                    print(x)
                    if ".png" not in x:
                        continue
                    retText, names = self.ConvertTileMap(self.dirTiles+x)
                    print(f"NAMES {names}")
                    fTile.writelines(retText)
                    for y in names:
                        if y=="NULL":
                            continue
                        indexT = int(y.split("_")[1].split(".")[0])
                        tilesD.update({indexT:y})
                        maxN  = max(maxN, indexT)

                fSV.writelines("SPRITES\n")
                listTile = ["NULL"]*(maxN+1)
                for k,v in zip(tilesD.keys(), tilesD.values()):
                    listTile[k]=v.split(".")[0]
                fSV.writelines(self.truncateText(listTile, "DC.L"))


                fSV.writelines("\n\n\n*~Font name~Courier New~\n")
                fSV.writelines("*~Font size~10~\n")
                fSV.writelines("*~Tab type~1~\n")
                fSV.writelines("*~Tab size~4~\n")

    def ConvertTileMap(self, path:str) -> list:
        # separar imagenes
        img = Image.open(path)
        tileMapName = path.split("/")[-1].split(".")[0]
        fulldir:str = self.dirOutTiles+tileMapName
        if os.path.exists(fulldir):
            shutil.rmtree(fulldir)
        os.mkdir(self.dirOutTiles+tileMapName)

        split_image(path, img.height//self.tilePixSize, img.width//self.tilePixSize,
                    False, False, output_dir=fulldir)
        
        #pasar a bmp RGBA normal, no indexado
        #https://stackoverflow.com/questions/68365846/pillow-np-how-to-convert-transparent-mapped-indexed-png-to-rgba-when-transpar

        newNames:list = ["NULL"]
        listdir = 0
        print(listdir)
        input("DEBUG")
        for x in os.listdir(fulldir):
            indexed = Image.open(fulldir+"/"+x)
            
            if indexed.mode == "P":
                # check if transparent
                is_transparent = indexed.info.get("transparency", False)
                
                if is_transparent is False:
                    # if not transparent, convert indexed image to RGB
                    image = indexed.convert("RGB")
                else:
                    # convert indexed image to RGBA
                    image = indexed.convert("RGBA")
            elif indexed.mode == 'PA':
                image = indexed.convert("RGBA")
            i = int(x.split("_")[1].split(".")[0])+1
            newName = f"{fulldir}/{tileMapName}_{i:>03}"
            newNames.append(f"{tileMapName}_{i:>03}")
            image.save(f"{newName}.png")
            indexed.close()
            os.remove(fulldir+"/"+x)



        retText:str = ""
        for x in os.listdir(self.dirOutTiles+tileMapName):
            rText,_ = self.ConvertSpriteBForce(fulldir+"/"+x)
            retText+=rText+"\n"

        return retText, newNames
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
        ret = f"00{ret[2:]}"
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

    def ToHexXY(self, x, y) -> str:
        return "$"+hex(round(x))[2:].upper().zfill(4)+hex(round(y))[2:].upper().zfill(4)

Conversor()
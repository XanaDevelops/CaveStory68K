#import simple_inkscape_scripting as sis
#from simpinkscr.simple_inkscape_scripting import *

#from simple_inkscape_scripting import all_shapes
from io import TextIOWrapper
import sys, os, subprocess, shutil
import multiprocessing
from PIL import Image
import numpy as np
import tmx
from split_image import split_image
from bruteforcer import frame_to_boxes
import inkex, inkex.command

try:
    rect
except NameError:
    print("hey")
    from simpinkscr import *
import contextlib

class Conversor():

    dirSprites  = "./svg/"
    dirSprBMP   = "./BMP/"
    dirMapas    = "./mapas/"
    dirSFX      = "./SFX/"
    dirBGM      = "./BGM/"
    dirTiled    = "./Tiled/"
    dirTiles    = "./BMP/tilemaps/"
    dirOutTiles = "./BMP/tiles/"
    dirTilesSVG = "./svg/TILES/"

    pathSprites = "./data/sprites.x68"
    pathTiles   = "./data/tiles.x68"
    pathMaps    = "./data/newMaps.x68"
    pathEntity  = "./data/newEntsData.x68"
    pathSI      = "./data/sounds.x68"
    pathSpriteV = "./data/SPRITEVECTOR.x68"

    tilePixSize = 16
    tileMult    = 4

    fileLock = multiprocessing.Lock()

    MAXPROCESS:int = os.cpu_count()
    #MAXPROCESS = 64
    activeProcess:list[multiprocessing.Process] = []
    waitProcess:list[multiprocessing.Process] = []

    cdasym="↑↓←→ZXASQW␛␜    "

    def __init__(self):
        print(f"NUMERO de subprocesos generables {self.MAXPROCESS}")
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
            print("     [5] ConvertPNG->SVG")
            print("     [6] ConvertSingle") 
            print("     [7] Split Image")
            print("     [8] Importar sonidos")    
            print("     [9] Modificar .CDAT (cinematicas)")
            print("     [10] Convert BMP to 68K Data (single DEPR)")              
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
                        self.ConvertIMGtoSVG(input("path: "),input("out: "))
                    case 6:
                        self.ConvertSpriteSVG(input("Path: "), True if input()=="" else False)
                    case 7:
                        self.SplitImage(input("Path: "), input("Out: "), int(input("H: ")), int(input("W: ")))
                    case 8:
                        self.SoundImport()
                    case 9:
                        self.EditCDAT()
                    case 10:
                        print(self.ConvertSpriteOld(input("path: "))[0], file=open("OUTPUT.x68", "w"))
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

        self.RecursiveConverter(self.dirSprites, False, self.fileLock)
        

            #fsprite.writelines(f"\nSPRITEV DC.L {', '.join(names)}\n")

        with open(self.pathSprites, "+a") as fsprite:
            for x in os.listdir(self.dirSprBMP):
                if(".bmp" in x):
                    ##cambiar por el normal...
                    fsprite.writelines(self.ConvertSpriteOld(self.dirSprBMP+"/"+x)[0])

            fsprite.writelines("\n\n\n*~Font name~Courier New~\n")
            fsprite.writelines("*~Font size~10~\n")
            fsprite.writelines("*~Tab type~1~\n")
            fsprite.writelines("*~Tab size~4~\n")

    def RecursiveConverter(self, path:str, tiles:bool=False, lock:multiprocessing.Lock = fileLock):
        fSV:TextIOWrapper
        maxN:int
        tilesD:dict
        if(tiles):
            fSV = open(self.pathSpriteV, "w")
            fSV.writelines("*-----------------------------------------------------------\n")
            fSV.writelines("* Title      : SpriteVector\n")
            fSV.writelines("* Written by : Xana\n")
            fSV.writelines("* Date       :\n")
            fSV.writelines("* Description: Generado automaticamente por pyconverterU.py\n")
            fSV.writelines("*-----------------------------------------------------------\n")
            maxN=0
            tilesD = dict()
        for x in os.listdir(path):
            #print("###############\n############")
            ###print("COMPROBANDO",path+"/"+x,os.path.isdir(path+"/"+x))
            #print("###############\n############")
            #input(path+x)
            if(os.path.isdir(path+x)):
                #print(f"AAAAAAAAAAAAAAAA: {path+x} {self.dirTilesSVG}")
                args:tuple
                if((path+x+"/") == self.dirTilesSVG):
                    self.RecursiveConverter(path+x+"/",True, lock)
                    #args = (path+x+"/",True, lock)
                else:
                    self.RecursiveConverter(path+x+"/", False, lock)
                    #args = (path+x+"/", False, lock)
                
                
            if(".svg" in x):
                #self.ConvertSpriteSVG(path+"/"+x, False, lock)
                proc = multiprocessing.Process(target=self.ConvertSpriteSVG,
                                               args=(path+"/"+x, False, lock))
                if len(self.activeProcess)>self.MAXPROCESS:
                    while(len(self.activeProcess)>self.MAXPROCESS):
                        print("ESPERANDO")
                        for p in self.activeProcess:
                            p.join()
                            self.activeProcess.remove(p)
                        for p in self.activeProcess:
                            if not p.is_alive():
                                self.activeProcess.remove(p)

                self.activeProcess.append(proc)
                proc.start()

                if(tiles):
                    indexT = int(x.split("_")[1].split(".")[0])
                    tilesD.update({indexT:x})
                    maxN  = max(maxN, indexT)

        for p in self.activeProcess:
            p.join()
            self.activeProcess.remove(p)

        if(tiles):
            fSV.writelines("SPRITES\n")
            listTile = ["NULL"]*(maxN+1)
            for k,v in zip(tilesD.keys(), tilesD.values()):
                listTile[k]=v.split(".")[0]
            fSV.writelines(self.truncateText(listTile, "DC.L"))
            fSV.writelines("\n\n\n*~Font name~Courier New~\n")
            fSV.writelines("*~Font size~10~\n")
            fSV.writelines("*~Tab type~1~\n")
            fSV.writelines("*~Tab size~4~\n")
            fSV.close()
  

    def ConvertSpriteSVG(self, path:str, verb:bool = False, lock:multiprocessing.Lock = fileLock) -> None:
        #os.popen(f"python .\simpinkscr\simple_inkscape_scripting.py --py-source=conversor.py .\sprites\dibujo.svg")
        #print(retText)
        if os.path.isdir(path):
            os.remove("CONVERSION_OUT.X68")
            
            for x in os.listdir(path):
                if ".svg" in x:
                    self.ConvertSpriteSVG(path+x, verb, lock)
            return
        with lock:
            if(not verb):
                devnull = open(os.devnull, "w")
                subprocess.run((f"python .\simpinkscr\simple_inkscape_scripting.py --py-source=conversor.py {path} {self.pathSprites} {path}".split()),
                            stdout=devnull)
                devnull.close()
            else:
                print("VERBOSE")
                devnull = open(os.devnull, "w")
                subprocess.run((f"python .\simpinkscr\simple_inkscape_scripting.py --py-source=conversor.py {path} CONVERSION_OUT.X68 {path}".split()),
                            stdout=devnull)
                devnull.close()

    def ConvertSpriteBForce(self, path:str, rawData:bool = False, verb:bool = False) -> list:
        img = Image.open(path)
        bmpName = path.split("/")[-1].split(".")[0].upper()
        print(path)
        

        colorText = f".Color:\n"
        sizeText = f".Size:\n"

        _sizes, _colors = frame_to_boxes(img, None)
        sizes = []
        for i in range(len(_sizes)):
            sizes.append(_sizes[i]*self.tileMult)
            if(i%4>=2):
                sizes[i]-=1
        #print(f"SIZES: {sizes}")
        ##print(f"COLORS {_colors}")
        colors=[]
        for x in _colors:
            colors.append(self.ToBGR(x))

        #colorText += "\tDC.L "+", ".join(colors)+"\n"
        colorText += self.truncateText(colors, "DC.L")
        sizesT = [str(z) for z in sizes]
        sizeText  += self.truncateText(sizesT, "DC.W")

        retText = f"\n{bmpName} DC.L .Color, .Size\n{colorText}\tDC.L -1\n{sizeText}\n\n"
        #print(retText)
        if(rawData):
            return sizes, _colors, bmpName
        
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
                        fname, w,h, tData, bData, oData = self.ConvertMapaTiled(self.dirTiled+x)
                        #fmap.writelines(f"{fname} DC.L .{fname}_DATA\n\t\tDC.W {w}, {h}\n")
                        #fmap.writelines(f".{fname}_DATA:\n{tData}\n")
                        names.append(fname)
                        mdata.append(
                            f".{fname} DC.L .{fname}_LAYER1, .{fname}_LAYER2\n\t\tDC.W {w}, {h}\n.{fname}_LAYER1:\n{tData}\n.{fname}_LAYER2:\n{bData}\n")
                        edata.append(f"{oData}\n")
                
                fmap.writelines(f"MAPS\tDC.L {', '.join([f'.{x}' for x in names])}\n")
                fmap.writelines("\n".join(mdata))
                fent.writelines(f"ENTINSTDATA\tDC.L {', '.join([f'.{x}' for x in names])}\n")
                fent.writelines("\n".join(edata))

    def ConvertMapaTiled(self, path:str) -> list:
        tmxF = tmx.TileMap.load(path)
        #importante orden dentro de Tiled
        tileLayer, objLayer, bgnLayer = tmxF.layers
        print(tileLayer, objLayer, bgnLayer)

        tmxName = path.split("/")[-1].split(".")[0].upper()
        tileData:str = ""
        bgnData:str = ""  #realmente bgn se pinta soble entidades, muy background no es...
        objData  = "."+tmxName+"\n"

        w,h = [tmxF.width, tmxF.height]
        for y in range(h):
            auxTile = []
            auxBgn = []
            for x in range(w):
                auxTile.append(str(tileLayer.tiles[x+y*w].gid))
                auxBgn.append(str(bgnLayer.tiles[x+y*w].gid))
            tileData += f"\tDC.W {','.join(auxTile)}\n"
            bgnData += f"\tDC.W {','.join(auxBgn)}\n"

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
        return tmxName, w,h, tileData, bgnData, objData
    
    def ConvertAllTileMaps(self):
        #Trocea imagen, convierte a svg para optimizar
        for x in os.listdir(self.dirTiles):
            # x es tilemap, formato png
            print(x)
            if ".png" not in x:
                continue
            #mirar en tmx el valor de tileset, QUE SEA CONSTANTE!!!!!!!
            '''
            <tileset firstgid="1" source="PrtCave.tsx"/>
            <tileset firstgid="81" source="NpcSym.tsx"/>
            <tileset firstgid="381" source="CAMARA.tsx"/>
            <tileset firstgid="383" source="NpcCemet.tsx"/>
            <tileset firstgid="523" source="MyChar.tsx"/>
            '''
            offset = int(x.split("_")[1].split(".")[0]) 
            self.ConvertTileMap(self.dirTiles+x, offset)



    def ConvertTileMap(self, path:str, offset:int) -> None:
        self.ConvertTileMap(path, self.dirOutTiles, offset)

    def ConvertTileMap(self, path:str, out:str, offset:int) -> None:
        # separar imagenes
        tileMapName = path.split("/")[-1].split(".")[0].split("_")[0]
        print(f"TILENAME: {tileMapName}")
        if(input(f"Replace {tileMapName}? [Y/N]: ").upper()!="Y"):
            print("NO reemplazo")
            return
        img = Image.open(path)
        print(f"PATH:::: {path}")
        
        fulldir:str = out+tileMapName
        if os.path.exists(fulldir):
            shutil.rmtree(fulldir)
        os.mkdir(out+tileMapName)

        split_image(path, img.height//self.tilePixSize, img.width//self.tilePixSize,
                    False, False, output_dir=fulldir)
        img.close()
        #pasar a bmp RGBA normal, no indexado
        #https://stackoverflow.com/questions/68365846/pillow-np-how-to-convert-transparent-mapped-indexed-png-to-rgba-when-transpar

        listdir = os.listdir(fulldir)
        #input(listdir)
        for x in listdir:
            indexed = Image.open(fulldir+"/"+x)
            
            if indexed.mode == "P":
                # check if transparent
                is_transparent = indexed.info.get("transparency", False)
                
                if is_transparent is False:
                    # if not transparent, convert indexed image to RGB
                    image = indexed.convert("RGBA")
                else:
                    # convert indexed image to RGBA
                    image = indexed.convert("RGBA")
            elif indexed.mode == 'PA':
                image = indexed.convert("RGBA")
            i = int(x.split("_")[2].split(".")[0])+1+offset

            newName = f"{fulldir}/{tileMapName}_{i:>03}"
            
            image.save(f"{newName}.png")
            indexed.close()
            print(f"to remove{fulldir}/{x}, saving {newName}.png")
            os.remove(fulldir+"/"+x)


        for x in os.listdir(self.dirOutTiles+tileMapName):
            self.ConvertIMGtoSVG(self.dirOutTiles+tileMapName+"/"+x, self.dirTilesSVG+x.replace(".png",".svg"))

    def SplitImage(self, path:str, out:str, h:int = 16, w:int = 16):
        img = Image.open(path)
        split_image(path, img.height//h,img.width//w, False, False, output_dir=out)
        img.close()
        tileMapName = os.path.basename(path).split(".")[0]
        print(tileMapName)
        listdir = os.listdir(out)
        #input(listdir)
        for x in listdir:
            indexed = Image.open(out+"/"+x)
            
            if indexed.mode == "P":
                # check if transparent
                is_transparent = indexed.info.get("transparency", False)
                
                if is_transparent is False:
                    # if not transparent, convert indexed image to RGB
                    image = indexed.convert("RGBA")
                else:
                    # convert indexed image to RGBA
                    image = indexed.convert("RGBA")
            elif indexed.mode == 'PA':
                image = indexed.convert("RGBA")
            i = int(x.split("_")[1].split(".")[0])

            newName = f"{out}/{tileMapName}_{i:>03}"
            
            image.save(f"{newName}.png")
            indexed.close()
            print(f"to remove{out}/{x}, saving {newName}.png")
            os.remove(out+"/"+x)

    def ConvertIMGtoSVG(self, path:str, out:str, lock:multiprocessing.Lock = fileLock):
        if os.path.isdir(path):
            for x in os.listdir(path):
                if ".png" in x:
                    x2 = x.replace(".png", ".svg")
                    #self.ConvertIMGtoSVG(path+x, path+x2)
                    proc = multiprocessing.Process(target=self.ConvertIMGtoSVG, args=(path+x, path+x2, lock))
                    if len(self.activeProcess)>self.MAXPROCESS:
                        while(len(self.activeProcess)>self.MAXPROCESS):
                            print("ESPERANDO")
                            for p in self.activeProcess:
                                p.join()
                                self.activeProcess.remove(p)
                            for p in self.activeProcess:
                                if not p.is_alive():
                                    self.activeProcess.remove(p)
                    self.activeProcess.append(proc)
                    proc.start()
            for p in self.activeProcess:
                p.join()
            return
        
        #convierte de img 
        sizes, colors, name = self.ConvertSpriteBForce(path, True)
        #print(colors)
        if(os.path.exists(out)):
            os.remove(out)
        #print(colors)
        with lock:
            devnull = open(os.devnull, "w")
            with open("auxfile.tmp", "w") as temp:
                temp.write(f"{'@'.join(str(x) for x in sizes)}\n"
                       +f"{'@'.join(y for y in ['#'.join([str(x[0]),str(x[1]),str(x[2])]) for x in colors])}")
        # crear archivo aux, path demasiado largo
            subprocess.run(((f"python .\simpinkscr\simple_inkscape_scripting.py --py-source=transform.py svg/PLANTILLA {out} auxfile.tmp").split()),
                       stdout=devnull)
            devnull.close()

    def EditCDAT(self):
        filename = input("\nEditor de CDAT: .cdat?: ")
        with open(filename, "+ab") as file:
            file.seek(0)
            print(f"RND SEED: {file.read(4).hex()} Frames: {(os.path.getsize(filename)-4)/2}")
            #print(self.cdasym)
            while(True):
                print(f"\t[1] Mostrar 20 siguientes frame actual:{(file.tell()-2)/2}")
                print("\t[2] Ir a frame")
                print("\n\t[0] Salir menu principal")
                c:int = int(input("CMD? "))
                match c:
                    case 1:
                        print("CABECERA")
                        linia = file.read(2)
                        for i in range(20):
                            if(linia==b""):
                                break
                            self.PrintFrame(linia.hex(), (file.tell()-2)/2)
                            linia = file.read(4)
                    case 0:
                        break
    def PrintFrame(self, data:str, frame:int)-> None:
        regs = [data[x:2+x] for x in range(0,8,2)]
        print(f"Frame:{frame}:\t {regs} {'|'.join([self.Symbolice(regs[x]) for x in range(4)])}")

    def Symbolice(self, data:str) -> str:
        bData = bin(int(data,16))[2:].zfill(8)
        #print(bData)
        return bData

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


if __name__ == "__main__":
    Conversor()
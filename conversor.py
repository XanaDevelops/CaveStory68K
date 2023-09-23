import sys, inkex, os


def ConvertSpriteSVG() -> list:
    SCALE = 2

    path = user_args[1]
    #print("CONVERSOR", path)
    svgName = path.split("/")[-1].split(".")[0].upper()

    colorText = f"Color{svgName}:\n"
    sizeText = f"Size{svgName}:\n"

    colors = []
    sizes = []

    for obj in my_all_shapes():
        try:
            actualColor = obj.style()["fill"][1:]
        except:
             print(f"ERROR en {path}: {obj}\n{obj.style()}")
             actualColor = "000000"
             input()
        #print(actualColor)
        colors.append(ToBGR([int(actualColor[2*x:2*x+2], 16) for x in range(len(actualColor)//2)]))

        #print(obj.bounding_box())
        A,B = obj.bounding_box()
        x1, x2 = [round(float(n))*SCALE for n in A]
        y1, y2 = [round(float(n))*SCALE for n in B]
        #print(x1,y1,x2,y2)
        [sizes.append(x) for x in [x1,y1,x2-1,y2-1]]


    colorText += truncateText(colors, "DC.L")
    sizesT = [str(z) for z in sizes]
    sizeText  += truncateText(sizesT, "DC.W")
        

    retText = f"{colorText}\tDC.L -1\n{sizeText}\n\n{svgName} DC.L Color{svgName}, Size{svgName}\n"
    #print("\n###########\nRETTEXT\n"+retText+"##################\n",user_args[0])
    with open(user_args[0], "+a") as sprites:
        sprites.write(retText)
        sprites.flush()
        os.fsync(sprites)

    #return [retText, svgName]

def my_all_shapes():
    '''Return a list of all shapes in the image as Simple Inkscape
    Scripting objects.  Layers do not count as shapes in this context.'''
    # Acquire the root of the SVG tree.
    global _simple_top
    svg = _simple_top.svg_root

    # Find all ShapeElements whose parent is a layer.
    layers = {g
              for g in svg.xpath('//svg:g')
              if g.get('inkscape:groupmode') == 'layer'}
    '''layer_shapes = [inkex_object(obj)
                    for lay in layers
                    for obj in lay
                    if isinstance(obj, inkex.ShapeElement)]'''
    templayers = []
    for lay in layers:
        tmplay = []
        #print(lay, dir(lay), lay.label)
        layerId = int(lay.label.split()[1])
        #print(f"layerid {layerId} de label {lay.label}", lay)
        for obj in lay:
            if isinstance(obj, inkex.ShapeElement):
                #print(obj)
                tmplay.append(obj)
            else:
                 print("NO")
        #print("lay", tmplay)
        templayers.append([tmplay, layerId])
    #print("old",templayers,"\n\n")
    templayers.sort(key=lambda x:x[1])
    #print("new",templayers,"\n\n")
    layer_shapes = []
    for layer in templayers:
         for obj in layer[0]:
            layer_shapes.append(inkex_object(obj))
    #print(layer_shapes,"\n")
    # Find all ShapeElements whose parent is the root.
    root_shapes = [inkex_object(obj)
                   for obj in svg
                   if isinstance(obj, inkex.ShapeElement) and
                   obj not in layers]

    # Return the combination of the two.
    return root_shapes + layer_shapes

def ToBGR(x:list):

        if(len(x)==3):
             x.append(0)

        r,g,b,a=x
        #print("ALFA",a) if a!=255 else None
        r=hex(r)[2:].upper().zfill(2)
        g=hex(g)[2:].upper().zfill(2)
        b=hex(b)[2:].upper().zfill(2)
        a=hex(a)[2:].upper().zfill(2)
        ret = a+b+g+r
        
        '''if ret=="00FFFFFF" or a=="00":
            ret="00000000"
            a="00"

        if a!="FF" and a!="00":
            print("Alpha erroneo, no 00 FF", file=sys.stderr)
            ret="00000000"'''
        
        return "$"+ret

def truncateText(text:list, dataSize:str, tam:int = 16 ) -> str:
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

if __name__ == "__main__":
    ConvertSpriteSVG()
def ConvertIMGtoSVG():
        #convierte de img 

        #print(len(user_args))
        #[print(x) for x in user_args]

        with open(user_args[1], "r") as temp:
             sizes = temp.readline()
             color = temp.readline()
             
        sizes = sizes.split("@")
        colors = [x.split("#") for x in color.split("@")]
        colors = ["#"+"".join([(f"{hex(int(y))[2:]:>02}") for y in x]) for x in colors]
        out = user_args[0]

        #print(f"SIZES TRANSFORM: {sizes}")
        #innecesario si plantilla
        '''canvas.width = 64
        canvas.height = 64
        canvas.true_width = 1
        canvas.true_height = 1'''

        lay1 = layer("Capa 1")

        for i in range(len(colors)):
            clr = colors[i]
            #print(clr)
            a,b,c,d = [int(x) for x in sizes[4*i:4*i+4]]
            lay1.append(rect((a//2,b//2),((c+1)//2,(d+1)//2),fill=clr, stroke=None))
        
        save_file(out)

if __name__ == "__main__":
    ConvertIMGtoSVG()
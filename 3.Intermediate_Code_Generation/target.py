reg = ['R0','R1','R2','R3','R4','R5','R6','R7']
cond = ['==','!=','>','<','>=','<=']
reg_val = {}
i = 0
def operation(l):
    
    global i
    
    r1 = assign(l[2])
    r2 = assign(l[4])
    r3 = reg[i]
    i=i+1
    if '+' in l:
        print("\tADD",r3,r2,r1)
        print("\tSTR",r3,l[0])
    if '-' in l:
        print("\tSUB",r3,r2,r1)
        print("\tSTR",r3,l[0])
    if '*' in l:
        print("\tMUL",r3,r2,r1)
        print("\tSTR",r3,l[0])
    if '/' in l:
        print("\tDIV",r3,r2,r1)
        print("\tSTR",r3,l[0])
    if i in l and i in cond:
        print("\tCMP",r1,r2)
def assign(val):
    global reg_val
    global i
    r = 0
    if(i == 7):
        i = 0
    else:
        for k in reg_val.keys():
            if(val == reg_val[k]):
                r = k
        print("\tMOV",reg[i],val)
        reg_val[r] = val
        r = reg[i]
    i = i + 1
    return r
   
if __name__ == "__main__":
    #global reg_val
    opt = open("Optimised.txt","r")
    for  l in opt:
        l = l.split()
        #print(line)
        if(len(l) == 3):
            register = assign(l[2])
            print("\tSTR",register,l[0])
        if(len(l) == 2):
            print("\tB ",l[1])
        if(len(l) == 4):
            print("\tB",l[3])
        if(len(l)==1):
            print(l[0])
        if(len(l)==5):
            operation(l)

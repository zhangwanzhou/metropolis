import numpy as np
ntime=100
nsteps=1000
nbin=5000 
m=np.loadtxt("32m.dat")
#print (np.size(m))
tobs=np.zeros(ntime)
#print (np.size(tobs))

i=0
for ib in range(nbin):
    count1 = 0
    count2 = 0m
    aobs = 0 
    acor = np.zeros(ntime)
    for ist in range(nsteps): 
        if (count1<ntime):
            tobs[ count1 ] = m[i]
           # print (count1,tobs[ count1] )
        else:
            aobs = aobs + m[i]
#            print (i,m[i])  
            count2 = count2 + 1
            
            for z in range(ntime-1): #i= 0, 1, 2,...,98
                tobs[z] = tobs[z+1]
            tobs[ntime-1]=m[i]#    99---update
            
            for z in range(ntime):
                acor[z] = acor[z] + tobs[0]*tobs[z]
#                print (ib,count2, z,acor[z]) 
#                print  (z,tobs[z]) 
        count1 = count1 + 1
        i=i+1
#    print (count2,'count2')      
    aobs=aobs/float(count2)
    acor=acor/float(count2)
    print aobs,aobs
    for z in range(ntime):
      print acor[z],acor[z]
   # exit() 


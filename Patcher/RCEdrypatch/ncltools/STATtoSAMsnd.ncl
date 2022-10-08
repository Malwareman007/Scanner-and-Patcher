
;305
;f=addfile("/global/home/users/langhans/sam/SAM6.10.10/OUT_STAT/RCE_4km_16x16x106_4km_10s_305K.nc","r")
;300
f=addfile("/global/home/users/langhans/sam/SAM6.10.10/OUT_STAT/RCE_4km_64x64x106_4km_20s.nc","r")

time=f->time
nstep=ind(abs(time-60.).eq.min(abs(time-60.)))
print("exctracting profile at time: "+ time(nstep) + " days")

z=f->z
nzm=dimsizes(z)
rv=f->QV(nstep,:)
th=f->THETA(nstep,:)

u=th
v=th
u=0.
v=0.
p=th
p=-999.

day0=0.0
psfc=1005.


 alist = [/z, p, th, rv, u, v/]

 header = (/"z[m] p[mb] tp[K] q[g/kg] u[m/s] v[m/s]", \
            "0., "+sprinti("%4.0i",nzm)+" "+sprintf("%4.1f",psfc) +" day,levels,pres0"/)

 hlist = [/header/]
 write_table("snd", "w", hlist, "%s")
 write_table("snd", "a", alist, "%8.2f%6.0f%6.2f%5.2f%6.2f%6.2f")



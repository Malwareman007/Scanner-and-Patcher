
f=addfile("./RCE_300/initialsounding_300K.nc","r")

rd=287.
cp=1004.

z=f->z
nzm=dimsizes(z)
p=f->p
tabs=f->tabs
qv=f->qv
rv=(qv/(1.-qv))*1000.
delete(qv)
th=tabs*(1.e5/p)^(rd/cp)
delete(tabs)

u=th
v=th
u=0.
v=0.
p=-999.

day0=0.0
psfc=1005.


 alist = [/z, p, th, rv, u, v/]

 header = (/"z[m] p[mb] tp[K] q[g/kg] u[m/s] v[m/s]", \
            "0., "+sprinti("%4.0i",nzm)+" "+sprintf("%4.1f",psfc) +" day,levels,pres0"/)

 hlist = [/header/]
 write_table("snd", "w", hlist, "%s")
 write_table("snd", "a", alist, "%8.2f%6.0f%6.2f%5.2f%6.2f%6.2f")



! Saturation vapor pressure and mixing ratio. 
! Based on Flatau et.al, (JAM, 1992:1507)
!

real function esatw(t)
implicit none
real t	! temperature (K)
real a0,a1,a2,a3,a4,a5,a6,a7,a8 
data a0,a1,a2,a3,a4,a5,a6,a7,a8 /&
!	6.105851, 0.4440316, 0.1430341e-1, &
!        0.2641412e-3, 0.2995057e-5, 0.2031998e-7, &
!        0.6936113e-10, 0.2564861e-13,-0.3704404e-15/
     	6.11239921, 0.443987641, 0.142986287e-1, &
       0.264847430e-3, 0.302950461e-5, 0.206739458e-7, &
       0.640689451e-10, -0.952447341e-13,-0.976195544e-15/
real dt
dt = max(-80.,t-273.16)
esatw = a0 + dt*(a1+dt*(a2+dt*(a3+dt*(a4+dt*(a5+dt*(a6+dt*(a7+a8*dt))))))) 
end
        
        
        
real function qsatw(t,p)
implicit none
real t	! temperature (K)
real p	! pressure    (mb)
real esat,esatw
esat = esatw(t)
qsatw = 0.622 * esat/max(esat,p-esat)
end
        
        
real function dtesatw(t)
implicit none
real t	! temperature (K)
real a0,a1,a2,a3,a4,a5,a6,a7,a8 
data a0,a1,a2,a3,a4,a5,a6,a7,a8 /&
          0.443956472, 0.285976452e-1, 0.794747212e-3, &
          0.121167162e-4, 0.103167413e-6, 0.385208005e-9, &
         -0.604119582e-12, -0.792933209e-14, -0.599634321e-17/
real dt
dt = max(-80.,t-273.16)
dtesatw = a0 + dt* (a1+dt*(a2+dt*(a3+dt*(a4+dt*(a5+dt*(a6+dt*(a7+a8*dt))))))) 
end
        
        
real function dtqsatw(t,p)
implicit none
real t	! temperature (K)
real p	! pressure    (mb)
real dtesatw
dtqsatw=0.622*dtesatw(t)/p
end
   
   
real function esati(t)
implicit none
real t	! temperature (K)
real a0,a1,a2,a3,a4,a5,a6,a7,a8 
data a0,a1,a2,a3,a4,a5,a6,a7,a8 /&
	6.11147274, 0.503160820, 0.188439774e-1, &
        0.420895665e-3, 0.615021634e-5,0.602588177e-7, &
        0.385852041e-9, 0.146898966e-11, 0.252751365e-14/	
real dt
real esatw
if(t.gt.273.15) then
  esati = esatw(t)
else if(t.gt.185.) then
  dt = t-273.16
  esati = a0 + dt*(a1+dt*(a2+dt*(a3+dt*(a4+dt*(a5+dt*(a6+dt*(a7+a8*dt))))))) 
else   ! use some additional interpolation below 184K
  dt = max(-100.,t-273.16)
  esati = 0.00763685 + dt*(0.000151069+dt*7.48215e-07)
end if
end
        
        
        
real function qsati(t,p)
implicit none
real t	! temperature (K)
real p	! pressure    (mb)
real esat,esati
esat=esati(t)
qsati=0.622 * esat/max(esat,p-esat)
end
        
        
real function dtesati(t)
implicit none
real t	! temperature (K)
real a0,a1,a2,a3,a4,a5,a6,a7,a8 
data a0,a1,a2,a3,a4,a5,a6,a7,a8 / &
	0.503223089, 0.377174432e-1,0.126710138e-2, &
	0.249065913e-4, 0.312668753e-6, 0.255653718e-8, &
	0.132073448e-10, 0.390204672e-13, 0.497275778e-16/
real dt
real dtesatw
if(t.gt.273.15) then
  dtesati = dtesatw(t)
else if(t.gt.185.) then
  dt = t-273.16
  dtesati = a0 + dt*(a1+dt*(a2+dt*(a3+dt*(a4+dt*(a5+dt*(a6+dt*(a7+a8*dt))))))) 
else  ! use additional interpolation below 185K
  dt = max(-100.,t-273.16)
  dtesati = 0.0013186 + dt*(2.60269e-05+dt*1.28676e-07)
end if
end
        
        
real function dtqsati(t,p)
implicit none
real t	! temperature (K)
real p	! pressure    (mb)
real dtesati
dtqsati=0.622*dtesati(t)/p
end
      

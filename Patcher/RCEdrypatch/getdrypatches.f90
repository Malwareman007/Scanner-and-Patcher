program getdrypatches

   use netcdf
   use netcdf_mod

   implicit none

   ! In
   character(200) :: filename,fileout

   ! Privates
   integer :: nx, ny, nz, nt, l, i, j, step, it, ndry,ntot, nb, ntotal, numpatch,idold,k
   integer, dimension(4) :: dimids
   integer, dimension(3) :: dimids2D
   integer :: xdimid, ydimid, zdimid, tdimid,  ncid,ncid2d, maskid, tauid, status, xcid, ycid
   real(8), dimension(:,:), allocatable :: tabs,u,v,qv,qn,qp,t,maskin, hlp
   real(8), dimension(:,:,:,:), allocatable :: tmp
   real(8), dimension(:,:,:), allocatable :: tmp2d,maskout,xcent,ycent
   real, dimension(:,:,:), allocatable :: tau,pw
   real(8), dimension(:), allocatable :: x,y,z, time,p,xcentvec
   real(8) :: dx, dy, shf, lhf, taux0, tauy0, minx, maxx, miny, maxy, xc, yc,xcold,ycold,dist,distx,disty,radold,rad,distold,&
              age, ageold
   logical :: file_exist, loverlap
   logical,parameter :: l3dneeded=.false.
   integer,parameter :: ntimes=240
   real, parameter  :: grav=9.81, cp=1005.,pwcrit=54.
   real(8),dimension(ntimes) :: timevec
   character(10) :: step_str 
   character(200) :: filein,filein2d
   real(8), dimension(:,:),allocatable:: x2d, y2d, x2do, y2do

   ! Read in filepath and t index
   call getarg(1,filename)
   call getarg(2,fileout)


   !open 2D file
   filein2d=trim(filename)//'.2Dcom_1.nc'
   ! Check that file exists
   inquire(file=trim(filein2d) ,exist=file_exist)
         if (.not.file_exist) then
            print *, 'Error: Can not find '//trim(filein2d)
          stop
         end if
         if (file_exist) then
            print *, 'file '//trim(filein2d)//' found.'
         end if
   call handle_err(nf90_open(path = filein2d, mode = nf90_nowrite, ncid = ncid2d))

   ! Retrieve dimensions, necessary to allocate arrays
   call handle_err(nf90_inq_dimid(ncid = ncid2d, name = 'x', dimid = xdimid))
   call handle_err(nf90_inq_dimid(ncid = ncid2d, name = 'y', dimid = ydimid))
   call handle_err(nf90_inq_dimid(ncid = ncid2d, name = 'time', dimid = tdimid))
   call handle_err(nf90_inquire_dimension(ncid = ncid2d, dimid = xdimid, len = nx))
   call handle_err(nf90_inquire_dimension(ncid = ncid2d, dimid = ydimid, len = ny))
   call handle_err(nf90_inquire_dimension(ncid = ncid2d, dimid = tdimid, len = nt))
   dimids2D = (/ xdimid, ydimid, tdimid /)
   write(*,*) 'nx,ny,nt =', nx, ny, nt
   ! Close netcdf file
   call handle_err(nf90_close(ncid = ncid2d))      

   allocate(tmp2d(nx,ny,1),maskin(nx,ny),maskout(nx,ny,ntimes),pw(nx,ny,ntimes),hlp(nx,ny),x2d(nx,ny),y2d(nx,ny),x2do(nx,ny),y2do(nx,ny),x(nx),y(ny))
   allocate(xcent(nx,ny,ntimes),ycent(nx,ny,ntimes))

   x = get_netCDF1(trim(filein2d),'x')
   y = get_netCDF1(trim(filein2d),'y')
   dx = x(2)-x(1)
   dy = y(2)-y(1)
   
   !start time loop
   ndry=0
   maskout=0.
   do it=1,nt

   ! get 2d variable 
     tmp2d = get_netCDF3(trim(filein2d),'PW', &
              start=(/ 1,1,it /), count=(/ nx,ny,1 /) ) 


 
     maskin=0.
     do i=1,nx
     do j=1,ny
       x2do(i,j)=x(i)
       y2do(i,j)=y(j)
   
       if (tmp2d(i,j,1).lt.pwcrit) then
         maskin(i,j)=1.
       end if

     end do
     end do

     ntot=1
     hlp=0.
     call clustering(hlp,ntot,&
                            maskin,0.,0.,4000.,4000.,nx,ny)
     maskout(:,:,it)=hlp

     
 
     write(*,*) 'Clustering done: ',ntot,' clusters'

     

     !apply size limit
     nb=1
     do while ( nb <= ntot )
       hlp=maskout(:,:,it)
       if (count(hlp.eq.float(nb)).lt.10) then
         WHERE (hlp(:,:) == float(nb))
            hlp(:,:) = 0.0
         ENDWHERE 
         WHERE (hlp(:,:) > float(nb))
            hlp(:,:) = hlp(:,:) - 1.
         ENDWHERE
         ntot=ntot-1.
       else
        nb=nb+1
       end if
       maskout(:,:,it)=hlp
     end do


     write(*,*) 'Size limiting done: ',ntot, ' clusters remaining'

     !compute centroid for each patch
     xcent(:,:,it)=0.
     ycent(:,:,it)=0.

     nb=1
     do while ( nb <= ntot )
       ! apply periodic BC if necessary
       x2d=x2do
       y2d=y2do
       hlp=maskout(:,:,it)
       numpatch=count(hlp(:,:) .EQ. float(nb))
       WHERE (hlp(:,:) .NE. float(nb)) 
         x2d(:,:) = 1.e9
       ENDWHERE
       minx=minval(x2d)
       WHERE (hlp(:,:) .NE. float(nb)) 
         x2d(:,:) = 0.
       ENDWHERE
       maxx=maxval(x2d)
       if ((maxx-minx).eq.x(nx)-x(1)) then
         if (count(hlp(:,:) .EQ. float(nb).and.x2d(:,:).ge.x(nx)/2.).gt.int(numpatch/2)) then
         WHERE (hlp(:,:) .EQ. float(nb).and.x2d(:,:).le.x(nx)/2.) 
           x2d(:,:) = x2d(:,:) + nx * dx
         ENDWHERE
         else
         WHERE (hlp(:,:) .EQ. float(nb).and.x2d(:,:).gt.x(nx)/2.) 
           x2d(:,:) = x2d(:,:) - nx * dx
         ENDWHERE
         end if
       end if

       WHERE (hlp(:,:) .NE. float(nb)) 
         y2d(:,:) = 1.e9
       ENDWHERE
       miny=minval(y2d)
       WHERE (hlp(:,:) .NE. float(nb)) 
         y2d(:,:) = 0.
       ENDWHERE
       maxy=maxval(y2d)
       if ((maxy-miny).eq.y(ny)-y(1)) then
         if (count(hlp(:,:) .EQ. float(nb).and.y2d(:,:).ge.y(ny)/2.).gt.int(numpatch/2)) then
         WHERE (hlp(:,:) .EQ. float(nb).and.y2d(:,:).le.y(ny)/2.) 
           y2d(:,:) = y2d(:,:) + ny * dy
         ENDWHERE
         else
         WHERE (hlp(:,:) .EQ. float(nb).and.y2d(:,:).gt.y(ny)/2.) 
           y2d(:,:) = y2d(:,:) - ny * dy
         ENDWHERE
         end if
       end if

       ! compute average x and y to get centroid
       WHERE (hlp(:,:) .EQ. float(nb))
         xcent(:,:,it) = sum(x2d)/count(hlp(:,:) .EQ. float(nb))  
         ycent(:,:,it) = sum(y2d)/count(hlp(:,:) .EQ. float(nb))  
       ENDWHERE
 
       nb=nb+1

     end do

     write(*,*) 'Computing centroids done'

     !increase dry patch IDs
     WHERE (maskout(:,:,it) > 0.)
            maskout(:,:,it) = maskout(:,:,it) + ndry
     ENDWHERE
     ndry=ndry+ntot

     !compute centroid distance to all patches that existed earlier
     !assign ID of old patch if distance smaller than old radius; uses
     !old patch closest by if multiple patches would qualify 
     if (it.gt.1) then

     hlp=maskout(:,:,it-1)
     WHERE (hlp(:,:) .GT. 0.)
         hlp(:,:) = 1.e7
     ENDWHERE

     if (maxval(maskout(:,:,it-1)).gt.0.) then

     nb=ndry-ntot+1
     do while ( nb <= ndry )
       hlp=xcent(:,:,it)
       WHERE (maskout(:,:,it).NE.nb)
         hlp(:,:) = 0.
       ENDWHERE
       xc = sum(hlp)/count(hlp.ne.0.)
       hlp=ycent(:,:,it)
       WHERE (maskout(:,:,it).NE.nb)
         hlp(:,:) = 0.
       ENDWHERE
       yc = sum(hlp)/count(hlp.ne.0.)
       rad=sqrt(dx*dy*count(hlp.ne.0.)/3.141592653)
 
       distold=1.e7

       idold=0
       do l=1,nb-1

         if (any(maskout(:,:,it-1).eq.l)) then

         hlp=xcent(:,:,it-1)
         WHERE (maskout(:,:,it-1).NE.l)
           hlp(:,:) = 0.
         ENDWHERE
         xcold = sum(hlp)/count(hlp.ne.0.)
         hlp=ycent(:,:,it-1)
         WHERE (maskout(:,:,it-1).NE.l)
           hlp(:,:) = 0.
         ENDWHERE
         ycold = sum(hlp)/count(hlp.ne.0.)
         radold=sqrt(dx*dy*count(hlp.ne.0.)/3.141592653)

         if (xcold>xc) then
           distx=min(abs(xcold-xc),abs(xc-xcold+nx*dx)) 
         else
           distx=min(abs(xcold-xc),abs(xc-xcold-nx*dx)) 
         end if
         if (ycold>yc) then
           disty=min(abs(ycold-yc),abs(yc-ycold+ny*dy)) 
         else
           disty=min(abs(ycold-yc),abs(yc-ycold-ny*dy)) 
         end if

         dist = sqrt(distx**2+disty**2) 
         
         !find patch closest by that also satisfies overlap OR distance criterion
         hlp=0.
         where (maskout(:,:,it).eq.nb.and.maskout(:,:,it-1).eq.l)
            hlp(:,:)=1.
         endwhere
         if (any(hlp.eq.1.)) then
           loverlap=.true.
         write(*,*) 'New patch ', nb ,' does overlap with old patch ', l 
         else
           loverlap=.false.
         write(*,*) 'New patch ', nb ,' does not overlap with old patch ', l 
         end if
         if (dist.lt.distold.and.(dist.le.2.*max(rad,radold).or.loverlap)) then
           distold=dist 
           idold=l
         end if

         end if

       end do

       if (idold.ne.0) then
         where (maskout(:,:,it).eq.nb)
           maskout(:,:,it) = idold
         endwhere
         where (maskout(:,:,it:nt).gt.nb)
           maskout(:,:,it:nt) = maskout(:,:,it:nt)-1.
         endwhere
         ndry=ndry-1
         ntot=ntot-1
       else
         nb=nb+1
       end if

     end do

     end if !patch exists at previous time
     
     end if !it > 1

     ! compute one centroid for all patches with same ID
     nb=1
     do while (nb.le.ndry)

       if (any(maskout(:,:,it).eq.nb)) then
    
       x2d=x2do
       y2d=y2do
       hlp=maskout(:,:,it)
       numpatch=count(hlp(:,:) .EQ. float(nb))
       WHERE (hlp(:,:) .NE. float(nb)) 
         x2d(:,:) = 1.e9
       ENDWHERE
       minx=minval(x2d)
       WHERE (hlp(:,:) .NE. float(nb)) 
         x2d(:,:) = 0.
       ENDWHERE
       maxx=maxval(x2d)
       if ((maxx-minx).eq.x(nx)-x(1)) then
         if (count(hlp(:,:) .EQ. float(nb).and.x2d(:,:).ge.x(nx)/2.).gt.int(numpatch/2)) then
         WHERE (hlp(:,:) .EQ. float(nb).and.x2d(:,:).le.x(nx)/2.) 
           x2d(:,:) = x2d(:,:) + nx * dx
         ENDWHERE
         else
         WHERE (hlp(:,:) .EQ. float(nb).and.x2d(:,:).gt.x(nx)/2.) 
           x2d(:,:) = x2d(:,:) - nx * dx
         ENDWHERE
         end if
       end if

       WHERE (hlp(:,:) .NE. float(nb)) 
         y2d(:,:) = 1.e9
       ENDWHERE
       miny=minval(y2d)
       WHERE (hlp(:,:) .NE. float(nb)) 
         y2d(:,:) = 0.
       ENDWHERE
       maxy=maxval(y2d)
       if ((maxy-miny).eq.y(ny)-y(1)) then
         if (count(hlp(:,:) .EQ. float(nb).and.y2d(:,:).ge.y(ny)/2.).gt.int(numpatch/2)) then
         WHERE (hlp(:,:) .EQ. float(nb).and.y2d(:,:).le.y(ny)/2.) 
           y2d(:,:) = y2d(:,:) + ny * dy
         ENDWHERE
         else
         WHERE (hlp(:,:) .EQ. float(nb).and.y2d(:,:).gt.y(ny)/2.) 
           y2d(:,:) = y2d(:,:) - ny * dy
         ENDWHERE
         end if
       end if

       ! compute average x and y to get centroid
       WHERE (hlp(:,:) .EQ. float(nb))
         xcent(:,:,it) = sum(x2d)/count(hlp(:,:) .EQ. float(nb))  
         ycent(:,:,it) = sum(y2d)/count(hlp(:,:) .EQ. float(nb))  
       ENDWHERE
 

       end if  ! patch ID exists

       nb=nb+1
     end do

     ! look for smaller patches in vicinity and merge them (ie assign ID of
     ! older or bigger (if same age) patch, recompute centroid for merged patch)
     nb=1
      do while (nb.le.ndry)
 
        ! check if patch ID exists
        if (any(maskout(:,:,it).eq.nb)) then


          !compute patches equivalent radius
         hlp=xcent(:,:,it)
         WHERE (maskout(:,:,it).NE.nb)
           hlp(:,:) = 0.
         ENDWHERE
         xc = sum(hlp)/count(hlp.ne.0.)
         hlp=ycent(:,:,it)
         WHERE (maskout(:,:,it).NE.nb)
           hlp(:,:) = 0.
         ENDWHERE
         yc = sum(hlp)/count(hlp.ne.0.)
         rad=sqrt(dx*dy*count(hlp.ne.0.)/3.141592653)
         age=0.
         l=1
         do while (l.lt.it)
           if (any(maskout(:,:,l).eq.nb)) age=age+1.
           l=l+1
         end do

         l=1
         do while (l.le.ndry)
 
            if (l.ne.nb) then
            
   
            if (any(maskout(:,:,it).eq.l)) then
   

            hlp=xcent(:,:,it)
            WHERE (maskout(:,:,it).NE.l)
              hlp(:,:) = 0.
            ENDWHERE
            xcold = sum(hlp)/count(hlp.ne.0.)
            hlp=ycent(:,:,it)
            WHERE (maskout(:,:,it).NE.l)
              hlp(:,:) = 0.
            ENDWHERE
            ycold = sum(hlp)/count(hlp.ne.0.)
            radold=sqrt(dx*dy*count(hlp.ne.0.)/3.141592653)
            ageold=0.
            k=1
            do while (k.lt.it)
              if (any(maskout(:,:,k).eq.l)) ageold=ageold+1.
              k=k+1
            end do
 
            if (ageold.lt.age.or.(ageold.eq.age.and.radold.lt.rad)) then
              ! merge smaller patch l into bigger patch nb if it's close enough
   
              if (xcold>xc) then
                distx=min(abs(xcold-xc),abs(xc-xcold+nx*dx)) 
              else
                distx=min(abs(xcold-xc),abs(xc-xcold-nx*dx)) 
              end if
              if (ycold>yc) then
                disty=min(abs(ycold-yc),abs(yc-ycold+ny*dy)) 
              else
                disty=min(abs(ycold-yc),abs(yc-ycold-ny*dy)) 
              end if
 
              dist = sqrt(distx**2+disty**2) 
          
              !check if smaller patch is close enough to be merged
              if (dist.le.(rad+40.e3)) then
 
                 !assign ID of bigger patch to smaller patch
                 where(maskout(:,:,it).eq.l)
                    maskout(:,:,it)=nb
                 endwhere

 
                 !recompute centroid of merged patch
                  x2d=x2do
                  y2d=y2do
                  hlp=maskout(:,:,it)
                  numpatch=count(hlp(:,:) .EQ. float(nb))
                  WHERE (hlp(:,:) .NE. float(nb)) 
                    x2d(:,:) = 1.e9
                  ENDWHERE
                  minx=minval(x2d)
                  WHERE (hlp(:,:) .NE. float(nb)) 
                    x2d(:,:) = 0.
                  ENDWHERE
                  maxx=maxval(x2d)
                  if ((maxx-minx).eq.x(nx)-x(1)) then
                    if (count(hlp(:,:) .EQ. float(nb).and.x2d(:,:).ge.x(nx)/2.).gt.int(numpatch/2)) then
                    WHERE (hlp(:,:) .EQ. float(nb).and.x2d(:,:).le.x(nx)/2.) 
                      x2d(:,:) = x2d(:,:) + nx * dx
                    ENDWHERE
                    else
                    WHERE (hlp(:,:) .EQ. float(nb).and.x2d(:,:).gt.x(nx)/2.) 
                      x2d(:,:) = x2d(:,:) - nx * dx
                    ENDWHERE
                    end if
                  end if
           
                  WHERE (hlp(:,:) .NE. float(nb)) 
                    y2d(:,:) = 1.e9
                  ENDWHERE
                  miny=minval(y2d)
                  WHERE (hlp(:,:) .NE. float(nb)) 
                    y2d(:,:) = 0.
                  ENDWHERE
                  maxy=maxval(y2d)
                  if ((maxy-miny).eq.y(ny)-y(1)) then
                    if (count(hlp(:,:) .EQ. float(nb).and.y2d(:,:).ge.y(ny)/2.).gt.int(numpatch/2)) then
                    WHERE (hlp(:,:) .EQ. float(nb).and.y2d(:,:).le.y(ny)/2.) 
                      y2d(:,:) = y2d(:,:) + ny * dy
                    ENDWHERE
                    else
                    WHERE (hlp(:,:) .EQ. float(nb).and.y2d(:,:).gt.y(ny)/2.) 
                      y2d(:,:) = y2d(:,:) - ny * dy
                    ENDWHERE
                    end if
                  end if
           
                  ! compute average x and y to get centroid
                  WHERE (hlp(:,:) .EQ. float(nb))
                    xcent(:,:,it) = sum(x2d)/count(hlp(:,:) .EQ. float(nb))  
                    ycent(:,:,it) = sum(y2d)/count(hlp(:,:) .EQ. float(nb))  
                  ENDWHERE

                 ! reduce ID by one if this completely killed the patch (it got
                 ! never born)
                 if (.not.any(maskout(:,:,1:it).eq.l)) then
                   ndry=ndry-1
                   !write(*,*)'ID ', l,' got merged into ID ',nb,' and no other patches with that ID exist' 
                   !if (any(maskout(:,:,:).gt.l)) then 
                   !    write(*,*) 'there are patches with IDs>',l
                   !end if
                   where (maskout(:,:,:).gt.l)
                      maskout(:,:,:)=maskout(:,:,:)-1.
                   endwhere
                   if (nb.gt.l) nb=nb-1
                 end if

              else
 
                l=l+1 ! patch l larger than patch nb
                 
              end if
            
 
            else
 
              l=l+1 ! patch l does not exist
   
            end if

            else   ! l does not exist
              l=l+1
            end if !
            
            else   ! nb=l
              l=l+1
            end if ! 
   
          end do
        

       end if

       nb=nb+1 ! jump to next patch and see if there are any smaller patches to
               ! be merged
     end do


     

     step = it*4320                       ! model step
     write(step_str,'(i10.10)') step
     write(*,*) 'Working on step ', step_str
     timevec(it) = step * 10. / 24. / 3600.  ! in days

     if (l3dneeded) then
     !3D filename
     filein=trim(filename)//'_'//trim(step_str)//'.nc'

   ! Check that file exists
   inquire(file=trim(filein) ,exist=file_exist)
         if (.not.file_exist) then
            print *, 'Error: Can not find '//trim(filein)
          stop
         end if
         if (file_exist) then
            print *, 'file '//trim(filein)//' found.'
         end if

  ! Open file 
   call handle_err(nf90_open(path = filein, mode = nf90_nowrite, ncid = ncid))

   ! Retrieve dimensions, necessary to allocate arrays
   call handle_err(nf90_inq_dimid(ncid = ncid, name = 'x', dimid = xdimid))
   call handle_err(nf90_inq_dimid(ncid = ncid, name = 'y', dimid = ydimid))
   call handle_err(nf90_inq_dimid(ncid = ncid, name = 'z', dimid = zdimid))
   call handle_err(nf90_inq_dimid(ncid = ncid, name = 'time', dimid = tdimid))
   call handle_err(nf90_inquire_dimension(ncid = ncid, dimid = xdimid, len = nx))
   call handle_err(nf90_inquire_dimension(ncid = ncid, dimid = ydimid, len = ny))
   call handle_err(nf90_inquire_dimension(ncid = ncid, dimid = zdimid, len = nz))
   call handle_err(nf90_inquire_dimension(ncid = ncid, dimid = tdimid, len = nt))
   dimids = (/ xdimid, ydimid, zdimid, tdimid /)
   if (it.eq.1) write(*,*) 'nx,ny,nz,nt =', nx, ny, nz, nt

   ! Allocate. Vars not allocated here are allocated in subroutines
   if (it.eq.1) then
      allocate( tabs(nx,ny), u(nx,ny), v(nx,ny), qv(nx,ny), qn(nx,ny), qp(nx,ny), t(nx,ny), tmp(nx,ny,1,1), &
         z(nz), p(nz), time(nt),tau(nx,ny,ntimes) )
      print *, 'Arrays allocated'
     ! Get input data
     z = get_netCDF1(trim(filein),'z')
     p = get_netCDF1(trim(filein),'p') 

     print *, 'Coordinates read in'
   end if

   time = get_netCDF1(trim(filein),'time')
   if (time(1).ne.timevec(it)) then
      write(*,*) 'ERROR: Time doesnt match' 
   end if


   tmp = get_netCDF4(trim(filein),'U', &
              start=(/ 1,1,1,1 /), count=(/ nx,ny,1,1 /) ) 
   u=tmp(:,:,1,1)
   tmp = get_netCDF4(trim(filein),'V', &
              start=(/ 1,1,1,1 /), count=(/ nx,ny,1,1 /) ) 
   v=tmp(:,:,1,1)
   tmp = get_netCDF4(trim(filein),'QV', &
              start=(/ 1,1,1,1 /), count=(/ nx,ny,1,1 /) ) 
   qv=tmp(:,:,1,1)
   tmp = get_netCDF4(trim(filein),'TABS', &
              start=(/ 1,1,1,1 /), count=(/ nx,ny,1,1 /) ) 
   tabs=tmp(:,:,1,1)
   tmp = get_netCDF4(trim(filein),'QN', &
              start=(/ 1,1,1,1 /), count=(/ nx,ny,1,1 /) ) 
   qn=tmp(:,:,1,1)
   tmp = get_netCDF4(trim(filein),'QP', &
              start=(/ 1,1,1,1 /), count=(/ nx,ny,1,1 /) ) 
   qp=tmp(:,:,1,1)

   print *, '4D data read in'
 
   t = tabs + 9.81/1005. * z(1) - 2.5d06/1005.*(qn + qp)

   ! Close netcdf file
   call handle_err(nf90_close(ncid = ncid))      

   end if !l3dneeded
    

   end do ! end of time loop

   ! WRITE netCDF
   
   ! open file 
   call handle_err(nf90_create(trim(fileout),nf90_clobber,ncid=ncid) )

   !  Define Dimensions
  call handle_err( nf90_def_dim(ncid,'x',nx,dimids2D(1)))
  call handle_err( nf90_def_dim(ncid,'y',ny,dimids2D(2)))
  call handle_err( nf90_def_dim(ncid,'time',ntimes,dimids2D(3)))
  !  Define Variables
  call handle_err( nf90_def_var(ncid,'x',nf90_float,dimids2D(1),xdimid) )
  call handle_err( nf90_def_var(ncid,'y',nf90_float,dimids2D(2),ydimid) )
  call handle_err( nf90_def_var(ncid,'time',nf90_float,dimids2D(3),tdimid) )
  call handle_err(nf90_def_var(ncid = ncid, name = 'mask', &
        xtype = nf90_float, dimids = dimids2D, varid = maskid ) )
  call handle_err(nf90_def_var(ncid = ncid, name = 'xc', &
        xtype = nf90_float, dimids = dimids2D, varid = xcid ) )
  call handle_err(nf90_def_var(ncid = ncid, name = 'yc', &
        xtype = nf90_float, dimids = dimids2D, varid = ycid ) )

        ! Add attributes
   call handle_err(nf90_put_att(ncid, maskid, 'long_name','Mask with custers' ))
   call handle_err(nf90_put_att(ncid, xcid, 'long_name','X-coordinate of patch centroid' ))
   call handle_err(nf90_put_att(ncid, ycid, 'long_name','Y-coordinate of patch centroid' ))
   call handle_err(nf90_put_att(ncid, xcid, 'units','m' ))
   call handle_err(nf90_put_att(ncid, ycid, 'units','m' ))
   call handle_err(nf90_enddef(ncid = ncid)) ! End define mode

        ! Write data
   call handle_err(nf90_put_var(ncid,xdimid,x))
   call handle_err(nf90_put_var(ncid,ydimid,y))
   call handle_err(nf90_put_var(ncid,tdimid,timevec))
   call handle_err(nf90_put_var(ncid,maskid,maskout))
   call handle_err(nf90_put_var(ncid,xcid,xcent))
   call handle_err(nf90_put_var(ncid,ycid,ycent))

   !call write_netCDF3(ncid,dimids((/1,2,4/)),'tau','m/s','Friction velocity',tau)

   ! Close netcdf file
   call handle_err(nf90_close(ncid = ncid))      



end program getdrypatches


program getcomposites

   use netcdf
   use netcdf_mod

   implicit none

   ! In
   character(200) :: filename,fileout

   ! Privates
   integer :: navg, nx, ny, nz, nt, n, k, l, i, j,  step, it, ndry,ntot, nb, ntotal, numpatch,idold,ntimes,nout,irec,is,it2
   integer,dimension(:),allocatable :: ic, jc
   integer, dimension(4) :: dimids
   integer, dimension(3) :: dimids2D
   integer :: xdimid,xdimidout, ydimid,ydimidout, zdimid,PWavgidout,PWinitidout,LHaccidout,RRaccidout,tdimid,tdimidout,IDdimidout,ncid,ncid2d, ncidout, maskid, tauid, status, xcid, ycid
   real(8), dimension(:,:), allocatable ::tabs,u,v,qv,qn,qp,t,hlp,pwavg,pwinit,lhacc,rracc
   real(8), dimension(:,:,:,:), allocatable :: tmp
   real(8), dimension(:,:,:), allocatable :: tmp2d,maskout,xcent,ycent,maskin,tmp2db,tmp2dc
   real, dimension(:,:,:), allocatable :: tau,pw
   real(8), dimension(:), allocatable :: x,y,z, time,p,xcentvec,xtmp,ytmp
   real(8) :: dx, dy, shf, lhf, taux0, tauy0, minx, maxx, miny, maxy, xc,yc,dist,distx,disty,radold,rad,distold
   logical :: file_exist, loverlap, lfound
   logical,parameter :: l3dneeded=.false.
   real, parameter  :: grav=9.81, cp=1005.,pwcrit=54.
   real(8),dimension(:),allocatable :: timevec
   character(10) :: step_str 
   character(200) :: filein,filein2d,filein3d
   real(8), dimension(:,:),allocatable:: x2d, y2d, x2do, y2do

   ! Read in filepath and t index
   call getarg(1,filein)
   call getarg(2,filein2d)
   call getarg(3,fileout)


   !open mask file
   ! Check that file exists
   inquire(file=trim(filein) ,exist=file_exist)
         if (.not.file_exist) then
            print *, 'Error: Can not find '//trim(filein)
          stop
         end if
         if (file_exist) then
            print *, 'file '//trim(filein)//' found.'
         end if
   call handle_err(nf90_open(path = filein, mode = nf90_nowrite, ncid = ncid))

   ! Retrieve dimensions, necessary to allocate arrays
   call handle_err(nf90_inq_dimid(ncid = ncid, name = 'x', dimid = xdimid))
   call handle_err(nf90_inq_dimid(ncid = ncid, name = 'y', dimid = ydimid))
   call handle_err(nf90_inq_dimid(ncid = ncid, name = 'time', dimid = tdimid))
   call handle_err(nf90_inquire_dimension(ncid = ncid, dimid = xdimid, len = nx))
   call handle_err(nf90_inquire_dimension(ncid = ncid, dimid = ydimid, len = ny))
   call handle_err(nf90_inquire_dimension(ncid = ncid, dimid = tdimid, len = nt))
   ntimes=nt
   dimids2D = (/ xdimid, ydimid, tdimid /)
   write(*,*) 'nx,ny,nt =', nx, ny, nt
   ! Close netcdf file
   call handle_err(nf90_close(ncid = ncid))      

   allocate(pwavg(nx,ny),pwinit(nx,ny),lhacc(nx,ny),rracc(nx,ny),tmp2d(nx,ny,1),& 
   maskin(nx,ny,nt),maskout(nx,ny,ntimes),pw(nx,ny,ntimes),hlp(nx,ny),&
   x2d(nx,ny),y2d(nx,ny),x2do(nx,ny),y2do(nx,ny),x(nx),y(ny),xtmp(nx),ytmp(ny))
   allocate(xcent(nx,ny,nt),ycent(nx,ny,nt),timevec(ntimes),ic(1),jc(1))

   x = get_netCDF1(trim(filein),'x')
   y = get_netCDF1(trim(filein),'y')
   dx = x(2)-x(1)
   dy = y(2)-y(1)
   timevec = get_netCDF1(trim(filein),'time')
   
   !get 2d variable 
    maskin = get_netCDF3(trim(filein),'mask', &
             start=(/ 1,1,1 /), count=(/ nx,ny,nt /) ) 
    xcent = get_netCDF3(trim(filein),'xc', &
             start=(/ 1,1,1 /), count=(/ nx,ny,nt /) ) 
    ycent = get_netCDF3(trim(filein),'yc', &
             start=(/ 1,1,1 /), count=(/ nx,ny,nt /) ) 
    ndry = int(maxval(maskin))

   !open output file 
   call handle_err(nf90_create(trim(fileout),nf90_clobber,ncid=ncidout) )
 !  Define Dimensions
   call handle_err( nf90_def_dim(ncidout,'x',nx,dimids(1)))
   call handle_err( nf90_def_dim(ncidout,'y',ny,dimids(2)))
   call handle_err( nf90_def_dim(ncidout,'time',1,dimids(3)))
   call handle_err( nf90_def_dim(ncidout,'ID',NF90_UNLIMITED,dimids(4)))
   !  Define Variables
   call handle_err( nf90_def_var(ncidout,'x',nf90_float,dimids(1),xdimidout) )
   call handle_err( nf90_def_var(ncidout,'y',nf90_float,dimids(2),ydimidout) )
   call handle_err( nf90_def_var(ncidout,'time',nf90_float,dimids(3),tdimidout) )
   call handle_err( nf90_def_var(ncidout,'ID',nf90_int,dimids(4),IDdimidout) )
   call handle_err(nf90_def_var(ncid = ncidout, name = 'PWavg', &
         xtype = nf90_float, dimids = dimids, varid = PWavgidout ) )
   call handle_err(nf90_def_var(ncid = ncidout, name = 'PWinit', &
         xtype = nf90_float, dimids = dimids, varid = PWinitidout ) )
   call handle_err(nf90_def_var(ncid = ncidout, name = 'LHacc', &
         xtype = nf90_float, dimids = dimids, varid = LHaccidout ) )
   call handle_err(nf90_def_var(ncid = ncidout, name = 'RRacc', &
         xtype = nf90_float, dimids = dimids, varid = RRaccidout ) )

        ! Add attributes
   call handle_err(nf90_put_att(ncid, PWavgidout, 'long_name','average PW' ))
   call handle_err(nf90_put_att(ncid, PWavgidout, 'units','mm' ))
   call handle_err(nf90_put_att(ncid, PWinitidout, 'long_name','initial PW' ))
   call handle_err(nf90_put_att(ncid, PWinitidout, 'units','mm' ))
   call handle_err(nf90_put_att(ncid, LHaccidout, 'long_name','LH supply -6-0' ))
   call handle_err(nf90_put_att(ncid, LHaccidout, 'units','J/m2' ))
   call handle_err(nf90_put_att(ncid, RRaccidout, 'long_name','RR supply -6-0' ))
   call handle_err(nf90_put_att(ncid, RRaccidout, 'units','mm' ))

   call handle_err(nf90_enddef(ncid = ncidout)) ! End define mode

   ! write coordinates
   call handle_err(nf90_put_var(ncidout,xdimidout,x))
   call handle_err(nf90_put_var(ncidout,ydimidout,y))
   call handle_err(nf90_put_var(ncidout,tdimidout,0.))

    !loop over all patches
    nout=0
    do n=1,ndry
      lfound=.false.
      navg=0 

      pwavg=0.
      do it=1,nt     
         if (any(maskin(:,:,it).eq.n)) then
            tmp2d = get_netCDF3(trim(filein2d),'PW', &
            start=(/ 1,1,it /), count=(/ nx,ny,1 /) ) 


            hlp=xcent(:,:,it)
            where(maskin(:,:,it).ne.n)
              hlp(:,:) = -1.e10
            endwhere   
            xc=maxval(hlp)
            hlp=ycent(:,:,it)
            where(maskin(:,:,it).ne.n)
              hlp(:,:) = -1.e10
            endwhere   
            yc=maxval(hlp)

            
            xtmp=abs(x(1:nx)-xc)
            ic(1)=minloc(xtmp,1)
            ytmp=abs(y(1:ny)-yc)
            jc(1)=minloc(ytmp,1)

            do i=1,nx
            do j=1,ny
 
              k= i + nx/2-ic(1)
              l= j + ny/2-jc(1)

              !periodicity
              if (k.gt.nx) k=k-nx
              if (k.lt.1)  k=k+nx
              if (l.gt.ny) l=l-ny
              if (l.lt.1)  l=l+ny


              pwavg(k,l) = pwavg(k,l) + tmp2d(i,j,1)
       

              if (.not.lfound) then 
                pwinit(k,l) = tmp2d(i,j,1)
              end if

            end do
            end do

            if (.not.lfound) then
 
              if (it.lt.13) then

                lhacc=-10.
                rracc=-10.

              else

              irec=8
              is=it-12
              allocate(tmp2db(nx,ny,1))
              allocate(tmp2dc(nx,ny,1))
              lhacc=0.
              rracc=0.
              do it2=is,is+irec-1
                 tmp2db = get_netCDF3(trim(filein2d),'LHF', &
                 start=(/ 1,1,it2 /), count=(/ nx,ny,1 /) ) 
                 tmp2dc = get_netCDF3(trim(filein2d),'Prec', &
                 start=(/ 1,1,it2 /), count=(/ nx,ny,1 /) ) 

                 do i=1,nx
                 do j=1,ny
 
                   k= i + nx/2-ic(1)
                   l= j + ny/2-jc(1)

                   !periodicity
                   if (k.gt.nx) k=k-nx
                   if (k.lt.1)  k=k+nx
                   if (l.gt.ny) l=l-ny
                   if (l.lt.1)  l=l+ny

                   lhacc(k,l) = lhacc(k,l) + tmp2db(i,j,1)
                   rracc(k,l) = rracc(k,l) + tmp2dc(i,j,1)

                 end do
                 end do

              end do
              lhacc=lhacc/float(irec)
              rracc=rracc/float(irec)
              deallocate(tmp2db)
              deallocate(tmp2dc)

              end if

            end if

 
            step = it*4320                       ! model step
            write(step_str,'(i10.10)') step
       
            if (l3dneeded) then
            !3D filename
            filein3d=trim(filename)//'_'//trim(step_str)//'.nc'
       
            ! Check that file exists
            inquire(file=trim(filein3d) ,exist=file_exist)
                  if (.not.file_exist) then
                     print *, 'Error: Can not find '//trim(filein3d)
                   stop
                  end if
                  if (file_exist) then
                     print *, 'file '//trim(filein3d)//' found.'
                  end if
         
           ! Open file 
            call handle_err(nf90_open(path = filein3d, mode = nf90_nowrite, ncid = ncid))
         
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
         
            ! Allocate. Vars not allocated here are allocated in subroutines
            if (n.eq.1.and..not.lfound) then
               allocate( tabs(nx,ny), u(nx,ny), v(nx,ny), qv(nx,ny), qn(nx,ny), qp(nx,ny), t(nx,ny), tmp(nx,ny,1,1), &
                  z(nz), p(nz), time(nt),tau(nx,ny,ntimes) )
              ! Get input data
              z = get_netCDF1(trim(filein3d),'z')
              p = get_netCDF1(trim(filein3d),'p') 
         
              print *, 'Coordinates read in'
            end if
         
            time = get_netCDF1(trim(filein3d),'time')
            if (time(1).ne.timevec(it)) then
               write(*,*) 'ERROR: Time doesnt match' 
            end if
         
         
            tmp = get_netCDF4(trim(filein3d),'U', &
                       start=(/ 1,1,1,1 /), count=(/ nx,ny,1,1 /) ) 
            u=tmp(:,:,1,1)
            tmp = get_netCDF4(trim(filein3d),'V', &
                       start=(/ 1,1,1,1 /), count=(/ nx,ny,1,1 /) ) 
            v=tmp(:,:,1,1)
            tmp = get_netCDF4(trim(filein3d),'QV', &
                       start=(/ 1,1,1,1 /), count=(/ nx,ny,1,1 /) ) 
            qv=tmp(:,:,1,1)
            tmp = get_netCDF4(trim(filein3d),'TABS', &
                       start=(/ 1,1,1,1 /), count=(/ nx,ny,1,1 /) ) 
            tabs=tmp(:,:,1,1)
            tmp = get_netCDF4(trim(filein3d),'QN', &
                       start=(/ 1,1,1,1 /), count=(/ nx,ny,1,1 /) ) 
            qn=tmp(:,:,1,1)
            tmp = get_netCDF4(trim(filein3d),'QP', &
                       start=(/ 1,1,1,1 /), count=(/ nx,ny,1,1 /) ) 
            qp=tmp(:,:,1,1)
         
            t = tabs + 9.81/1005. * z(1) - 2.5d06/1005.*(qn + qp)
         
            ! Close netcdf file
            call handle_err(nf90_close(ncid = ncid))      
         
            end if !l3dneeded



            lfound=.true.
            navg = navg + 1
    
         end if
      end do ! end of time loop

      !average patch properties
      pwavg = pwavg/float(navg)


      ! Write data
      if (navg.ge.2) then
        nout=nout+1
        call handle_err(nf90_put_var(ncidout,PWavgidout,pwavg,(/1,1,1,nout/),(/nx,ny,1,1/)))
        call handle_err(nf90_put_var(ncidout,PWinitidout,pwinit,(/1,1,1,nout/),(/nx,ny,1,1/)))
        call handle_err(nf90_put_var(ncidout,LHaccidout,lhacc,(/1,1,1,nout/),(/nx,ny,1,1/)))
        call handle_err(nf90_put_var(ncidout,RRaccidout,rracc,(/1,1,1,nout/),(/nx,ny,1,1/)))
        !call handle_err(nf90_put_var(ncid,xcid,xcent))
        !call handle_err(nf90_put_var(ncid,ycid,ycent))
      end if

      !call write_netCDF3(ncid,dimids((/1,2,4/)),'tau','m/s','Friction velocity',tau)


   end do ! end of loop over dry patches

   ! Close netcdf file
   call handle_err(nf90_close(ncid = ncidout))      



end program getcomposites


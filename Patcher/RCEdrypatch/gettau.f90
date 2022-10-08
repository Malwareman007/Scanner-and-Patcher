program gettau

   use netcdf
   use netcdf_mod

   implicit none

   ! In
   character(200) :: filename,fileout

   ! Privates
   integer :: nx, ny, nz, nt, l, i, j, step, it
   integer, dimension(4) :: dimids
   integer :: xdimid, ydimid, zdimid, tdimid,  ncid, tauid, status
   real(8), dimension(:,:), allocatable :: tabs,u,v,qv,qn,qp,t
   real(8), dimension(:,:,:,:), allocatable :: tmp
   real, dimension(:,:,:), allocatable :: tau
   real(8), dimension(:), allocatable :: x,y,z, time,p
   real(8) :: dx, dy, shf, lhf, taux0, tauy0
   logical :: file_exist
   integer,parameter :: ntimes=960
   real, parameter  :: grav=9.81, cp=1005.
   real(8),dimension(ntimes) :: timevec
   character(10) :: step_str 
   character(200) :: filein

   ! Read in filepath and t index
   call getarg(1,filename)
   call getarg(2,fileout)


   do it=1,ntimes

     step = it*1080                       ! model step
     write(step_str,'(i10.10)') step
     write(*,*) 'Working on step ', step_str
     timevec(it) = step * 10. / 24. / 3600.  ! in days
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
        x(nx), y(ny), z(nz), p(nz), time(nt),tau(nx,ny,ntimes) )
      print *, 'Arrays allocated'
     ! Get input data
     x = get_netCDF1(trim(filein),'x')
     y = get_netCDF1(trim(filein),'y')
     z = get_netCDF1(trim(filein),'z')
     p = get_netCDF1(trim(filein),'p') 
     dx = x(2)-x(1)
     dy = y(2)-y(1)

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

   ! get tau
   do j=1,ny
      do i=1,nx

       if (i.eq.nx.and.j.lt.ny) then
           call oceflx(p(1),0.5*(u(1,j)+u(i,j)), &
                       0.5*(v(i,j+1)+v(i,j)), &
                       t(i,j)-grav/cp*z(1),qv(i,j),t(i,j),z(1), &
                       305., shf, lhf, taux0, tauy0)
           tau(i,j,it)  = (taux0**2  +  tauy0**2)**0.5
       
       elseif (j.eq.ny.and.i.lt.nx) then
           call oceflx(p(1),0.5*(u(i,j)+u(i+1,j)), &
                       0.5*(v(i,1)+v(i,j)), &
                       t(i,j)-grav/cp*z(1),qv(i,j),t(i,j),z(1), &
                       305., shf, lhf, taux0, tauy0)
           tau(i,j,it)  = (taux0**2  +  tauy0**2)**0.5
           

       elseif (j.eq.ny.and.i.eq.nx) then
           call oceflx(p(1),0.5*(u(i,j)+u(1,j)), &
                       0.5*(v(i,1)+v(i,j)), &
                       t(i,j)-grav/cp*z(1),qv(i,j),t(i,j),z(1), &
                       305., shf, lhf, taux0, tauy0)
           tau(i,j,it)  = (taux0**2  +  tauy0**2)**0.5
 
       else
           call oceflx(p(1),0.5*(u(i+1,j)+u(i,j)), &
                       0.5*(v(i,j+1)+v(i,j)), &
                       t(i,j)-grav/cp*z(1),qv(i,j),t(i,j),z(1), &
                       305., shf, lhf, taux0, tauy0)
           tau(i,j,it)  = (taux0**2  +  tauy0**2)**0.5
 
       end if

      end do
    end do
    

   end do ! end of time loop

   ! WRITE netCDF
   
   ! open file 
   call handle_err(nf90_create(trim(fileout),nf90_clobber,ncid=ncid) )

   !  Define Dimensions
  call handle_err( nf90_def_dim(ncid,'x',nx,dimids(1)))
  call handle_err( nf90_def_dim(ncid,'y',ny,dimids(2)))
  call handle_err( nf90_def_dim(ncid,'z',1,dimids(3)))
  call handle_err( nf90_def_dim(ncid,'time',ntimes,dimids(4)))
  !  Define Variables
  call handle_err( nf90_def_var(ncid,'x',nf90_float,dimids(1),xdimid) )
  call handle_err( nf90_def_var(ncid,'y',nf90_float,dimids(2),ydimid) )
  call handle_err( nf90_def_var(ncid,'z',nf90_float,dimids(3),zdimid) )
  call handle_err( nf90_def_var(ncid,'time',nf90_float,dimids(4),tdimid) )
  call handle_err(nf90_def_var(ncid = ncid, name = 'tau', &
        xtype = nf90_float, dimids = dimids((/1,2,4/)), varid = tauid ) )

        ! Add attributes
   call handle_err(nf90_put_att(ncid, tauid, 'units', 'kg/m3 (m/s)2'))
   call handle_err(nf90_put_att(ncid, tauid, 'long_name','Surface Reynolds stress' ))
   call handle_err(nf90_enddef(ncid = ncid)) ! End define mode

        ! Write data
   call handle_err(nf90_put_var(ncid,xdimid,x))
   call handle_err(nf90_put_var(ncid,ydimid,y))
   call handle_err(nf90_put_var(ncid,zdimid,z(1)))
   call handle_err(nf90_put_var(ncid,tdimid,timevec))
   call handle_err(nf90_put_var(ncid,tauid,tau))

   !call write_netCDF3(ncid,dimids((/1,2,4/)),'tau','m/s','Friction velocity',tau)

   ! Close netcdf file
   call handle_err(nf90_close(ncid = ncid))      



end program gettau


!=================================!
!  Netcdf module                  !
!                                 !
!  Tools for working with netCDF  !
!  files                          !
!                                 !
!  Copyright (c) Jacob T. Seeley  !
!  http://www.romps.org           !
!=================================!

module netcdf_mod

   use netcdf

   implicit none
 

   contains

! This suite of functions should be generic functions, with a 'module procedure' interface
! block, following the example of thetae_scalar, thetae_vector, thetae_matrix in thermo_mod.
! Haven't gotten around to this yet. All the get_netCDF functions do essentially the
! same thing, for data of different dimensions. See get_netCDF2 for full functionality comments.

		!==========================!
		! get_netCDF0              !
      !                          !
		! Fetch a scalar variable  !
		! from a netCDF file       !
		!==========================!
      function get_netCDF0(filename, var_name)

         implicit none

         ! In
         character(*), intent(in) :: filename, var_name

         ! Private
         integer :: ncid, varid, ndims
         logical :: file_exist

         ! Out
         real :: get_netCDF0

         inquire(file=trim(filename),exist=file_exist)
         if (.not.file_exist) then
            print *, 'Error in get_netCDF0: Can not find '//trim(filename)
            stop
         end if

         if (nf90_open(path = trim(filename), mode = nf90_nowrite, ncid = ncid) .ne. nf90_noerr) then
            call handle_err(nf90_open(path=trim(filename),mode=nf90_nowrite,ncid=ncid) )
            print *, 'Error in get_netCDF0: Can not open '//trim(filename)
            stop
         end if

         call handle_err(nf90_inq_varid(ncid = ncid, name = trim(var_name), varid = varid) )
         
         call handle_err(nf90_inquire_variable(ncid = ncid, varid = varid, ndims = ndims ) )
         
         if (ndims .ne. 0) then
            print *, 'Error in get_netCDF0: Dimension mismatch for '//trim(var_name)
            stop
         end if
          
         call handle_err(nf90_get_var(ncid = ncid, varid = varid, values = get_netCDF0) ) 

         call handle_err(nf90_close(ncid = ncid))
      
      end function get_netCDF0

		!==========================!
		! get_netCDF1              !
      !                          !
		! Fetch a 1D variable      !
		! from a netCDF file       !
		!==========================!
      function get_netCDF1(filename, var_name, start, count, stride)

         implicit none

         ! In
         character(*), intent(in) :: filename, var_name
         integer, dimension(1), optional, intent(in) :: start, count, stride

         ! Private
         integer :: status, ncid, varid, ndims, dimlen
         integer, dimension(1) :: start2, count2, stride2
         integer, dimension(nf90_max_var_dims) :: dimids
         logical :: file_exist
         character(nf90_max_name) :: dimname

         ! Out
         real, dimension(:), allocatable :: get_netCDF1
         
         inquire(file=trim(filename),exist=file_exist)
         if (.not.file_exist) then
            print *, 'Error in get_netCDF1: Can not find '//trim(filename)
            stop
         end if

         if (nf90_open(path = trim(filename), mode = nf90_nowrite, ncid = ncid) .ne. nf90_noerr) then
            call handle_err(nf90_open(path=trim(filename),mode=nf90_nowrite,ncid=ncid) )
            print *, 'Error in get_netCDF1: Can not open '//trim(filename)
            stop
         end if

         call handle_err(nf90_inq_varid(ncid = ncid, name = trim(var_name), varid = varid) )
         
         call handle_err(nf90_inquire_variable(ncid = ncid, varid = varid, ndims = ndims, dimids = dimids ) )
         
         if (ndims .ne. 1) then
            print *, 'Error in get_netCDF1: Dimension mismatch for '//trim(var_name)
            stop
         end if
         
         call handle_err(nf90_inquire_dimension(ncid = ncid, dimid = dimids(1), name = dimname, len = dimlen ) ) 

         if (present(start) ) then
            start2 = start
         else 
            start2 = (/ 1 /)
         end if

         if (present(count) ) then
            count2 = count
            allocate( get_netCDF1(count(1)) )
         else
            count2 = (/ dimlen /)
            allocate( get_netCDF1(dimlen) )
         end if

         if (present(stride) ) then
            stride2 = stride
         else
            stride2 = (/ 1 /)
         end if
         if (any((start2+count2-(/ 1 /)) .gt. (/ dimlen /))) then
            print *, "Error in get_netCDF1: Index exceeds dimension bound"
            print *, start2
            print *, count2
            print *, (/ dimlen /)
            stop
         end if
         
         call handle_err(nf90_get_var(ncid = ncid, varid = varid, values = get_netCDF1, start = start2, count = count2, stride = stride2) ) 

         call handle_err(nf90_close(ncid = ncid))

      end function get_netCDF1

		!==========================!
		! get_netCDF2              !
      !                          !
		! Fetch a 2D variable      !
		! from a netCDF file       !
		!==========================!
      function get_netCDF2(filename, var_name, start, count, stride)

         implicit none

         ! In
         character(*), intent(in) :: filename, var_name
         integer, dimension(2), optional, intent(in) :: start, count, stride

         ! Private
         integer :: ncid, varid, ndims, dimlen1, dimlen2
         integer, dimension(2) :: start2, count2, stride2
         integer, dimension(nf90_max_var_dims) :: dimids
         logical :: file_exist
         character(nf90_max_name) :: dimname1, dimname2

         ! Out
         real, dimension(:,:), allocatable :: get_netCDF2

         ! Check that netCDF file exists
         inquire(file=trim(filename),exist=file_exist)
         if (.not.file_exist) then
            print *, 'Error in get_netCDF2: Can not find '//trim(filename)
            stop
         end if

         ! Open netCDF file
         if (nf90_open(path = trim(filename), mode = nf90_nowrite, ncid = ncid) .ne. nf90_noerr) then
            call handle_err(nf90_open(path=trim(filename),mode=nf90_nowrite,ncid=ncid) )
            print *, 'Error in get_netCDF2: Can not open '//trim(filename)
            stop
         end if

         ! Get the variable ID
         call handle_err(nf90_inq_varid(ncid = ncid, name = trim(var_name), varid = varid) )

			! Get the number of dimensions and dimension IDs
         call handle_err(nf90_inquire_variable(ncid = ncid, varid = varid, ndims = ndims, dimids = dimids ) )

			! Check that the variable is 2D
         if (ndims .ne. 2) then
            print *, 'Error in get_netCDF2: Dimension mismatch for '//trim(var_name)
            stop
         end if

         ! Get the dimension lengths
         call handle_err(nf90_inquire_dimension(ncid = ncid, dimid = dimids(1), name = dimname1, len = dimlen1 ) ) 
         call handle_err(nf90_inquire_dimension(ncid = ncid, dimid = dimids(2), name = dimname2, len = dimlen2 ) ) 

         ! Define start, count, and stride (defaults if not present as input parameters)
         if (present(start) ) then
            start2 = start
         else 
            start2 = (/ 1,1 /)
         end if

         if (present(count) ) then
            count2 = count
            allocate( get_netCDF2(count(1),count(2)) )
         else
            count2 = (/ dimlen1,dimlen2 /)
            allocate( get_netCDF2(dimlen1,dimlen2) )
         end if

         if (present(stride) ) then
            stride2 = stride
         else
            stride2 = (/ 1,1 /)
         end if

         ! Check that all requested data is within varable bounds
         if (any((start2+count2-(/ 1,1 /)) .gt. (/ dimlen1,dimlen2 /))) then
            print *, "Error in get_netCDF2: Index exceeds dimension bound"
            print *, start2
            print *, count2
            print *, (/ dimlen1,dimlen2 /)
            stop
         end if

         ! Read in the data
         call handle_err(nf90_get_var(ncid = ncid, varid = varid, values = get_netCDF2, start = start2, count = count2, stride = stride2) ) 

         ! Close the netCDF file
         call handle_err(nf90_close(ncid = ncid))
      
      end function get_netCDF2

		!==========================!
		! get_netcdf3              !
                !                          !
		! Fetch a 3D variable      !
		! from a netCDF file       !
		!==========================!
      function get_netCDF3(filename, var_name, start, count, stride)

         implicit none

         ! In
         character(*), intent(in) :: filename, var_name
         integer, dimension(3), optional, intent(in) :: start, count, stride

         ! Private
         integer :: ncid, varid, ndims, dimlen1, dimlen2, dimlen3
         integer, dimension(3) :: start2, count2, stride2
         integer, dimension(nf90_max_var_dims) :: dimids
         logical :: file_exist
         character(nf90_max_name) :: dimname1, dimname2, dimname3

         ! Out
         real, dimension(:,:,:), allocatable :: get_netCDF3

 
         inquire(file=trim(filename),exist=file_exist)
         if (.not.file_exist) then
            print *, 'Error in get_netCDF3: Can not find '//trim(filename)
            stop
         end if

         if (nf90_open(path=trim(filename), mode=nf90_nowrite, ncid=ncid) .ne. nf90_noerr) then
            call handle_err(nf90_open(path=trim(filename),mode=nf90_nowrite,ncid=ncid) )
            print *, 'Error in get_netCDF3: Can not open '//trim(filename)
            stop
         end if

         call handle_err(nf90_inq_varid(ncid = ncid, name = trim(var_name), varid = varid) )
         
         call handle_err(nf90_inquire_variable(ncid = ncid, varid = varid, ndims = ndims, dimids = dimids ) )

         if (ndims .ne. 3) then
            print *, 'Error in get_netCDF3: Dimension mismatch for '//trim(var_name)
            stop
         end if
         
         call handle_err(nf90_inquire_dimension(ncid = ncid, dimid = dimids(1), name = dimname1, len = dimlen1 ) ) 
         call handle_err(nf90_inquire_dimension(ncid = ncid, dimid = dimids(2), name = dimname2, len = dimlen2 ) ) 
         call handle_err(nf90_inquire_dimension(ncid = ncid, dimid = dimids(3), name = dimname3, len = dimlen3 ) ) 

         if (present(start) ) then
            start2 = start
         else 
            start2 = (/ 1,1,1 /)
         end if

         if (present(count) ) then
            count2 = count
            allocate( get_netCDF3(count(1),count(2),count(3)) )
         else
            count2 = (/ dimlen1,dimlen2,dimlen3 /)
            allocate( get_netCDF3(dimlen1,dimlen2,dimlen3) )
         end if

         if (present(stride) ) then
            stride2 = stride
         else
            stride2 = (/ 1,1,1 /)
         end if

         if (any((start2+count2-(/ 1,1,1 /)) .gt. (/ dimlen1,dimlen2,dimlen3 /))) then
            print *, "Error in get_netCDF3: Index exceeds dimension bound"
            print *, start2
            print *, count2
            print *, (/ dimlen1,dimlen2,dimlen3 /)
            stop
         end if
         call handle_err(nf90_get_var(ncid = ncid, varid = varid, values = get_netCDF3, start = start2, count = count2, stride = stride2) ) 

         call handle_err(nf90_close(ncid = ncid))
      
      end function get_netCDF3

		!==========================!
		! get_netCDF4              !
      !                          !
		! Fetch a 4D variable      !
		! from a netCDF file       !
		!==========================!
      function get_netCDF4(filename, var_name, start, count, stride)

         implicit none

         ! In
         character(*), intent(in) :: filename, var_name
         integer, dimension(4), optional, intent(in) :: start, count, stride

         ! Private
         integer :: ncid, varid, ndims, dimlen1, dimlen2, dimlen3, dimlen4
         integer, dimension(4) :: start2, count2, stride2
         integer, dimension(nf90_max_var_dims) :: dimids
         logical :: file_exist
         character(nf90_max_name) :: dimname1, dimname2, dimname3, dimname4

         ! Out
         real, dimension(:,:,:,:), allocatable :: get_netCDF4
        
         inquire(file=trim(filename),exist=file_exist)
         if (.not.file_exist) then
            print *, 'Error in get_netCDF4: Can not find '//trim(filename)
            stop
         end if

         if (nf90_open(path = trim(filename), mode = nf90_nowrite, ncid = ncid) .ne. nf90_noerr) then 
            call handle_err(nf90_open(path = trim(filename), mode = nf90_nowrite, ncid = ncid) )
            print *, 'Error in get_netCDF4: Can not open '//trim(filename)
            stop
         end if

         call handle_err(nf90_inq_varid(ncid = ncid, name = trim(var_name), varid = varid) )
         
         call handle_err(nf90_inquire_variable(ncid = ncid, varid = varid, ndims = ndims, dimids = dimids ) )

         if (ndims .ne. 4) then
            print *, 'Error in get_netCDF4: Dimension mismatch for '//trim(var_name)
            stop
         end if
         
         call handle_err(nf90_inquire_dimension(ncid = ncid, dimid = dimids(1), name = dimname1, len = dimlen1 ) ) 
         call handle_err(nf90_inquire_dimension(ncid = ncid, dimid = dimids(2), name = dimname2, len = dimlen2 ) ) 
         call handle_err(nf90_inquire_dimension(ncid = ncid, dimid = dimids(3), name = dimname3, len = dimlen3 ) ) 
         call handle_err(nf90_inquire_dimension(ncid = ncid, dimid = dimids(4), name = dimname3, len = dimlen4 ) ) 

         if (present(start) ) then
            start2 = start
         else 
            start2 = (/ 1,1,1,1 /)
         end if

         if (present(count) ) then
            count2 = count
            allocate( get_netCDF4(count(1),count(2),count(3),count(4)) )
         else
            count2 = (/ dimlen1,dimlen2,dimlen3,dimlen4 /)
            allocate( get_netCDF4(dimlen1,dimlen2,dimlen3,dimlen4) )
         end if

         if (present(stride) ) then
            stride2 = stride
         else
            stride2 = (/ 1,1,1,1 /)
         end if
         if (any((start2+count2-(/ 1,1,1,1 /)) .gt. (/ dimlen1,dimlen2,dimlen3,dimlen4 /))) then
            print *, "Error in get_netCDF4: Index exceeds dimension bound"
            print *, start2
            print *, count2
            print *, (/ dimlen1,dimlen2,dimlen3,dimlen4 /)
            stop
         end if

         call handle_err(nf90_get_var(ncid = ncid, varid = varid, values = get_netCDF4, start = start2, count = count2, stride = stride2) ) 

         call handle_err(nf90_close(ncid = ncid))

      end function get_netCDF4

      !============================!
      !  Subroutine write_netCDF1  !
      !                            !
      !  Write 1D field to given   !
      !  netCDF file               !
      !============================!

      subroutine write_netCDF1(ncid,dimid,varname,units,longname,data) 

        implicit none

        !In
        integer, intent(in) :: ncid
        integer, dimension(1) :: dimid
        character(*), intent(in) :: varname, units, longname
        real, intent(in), dimension(:) :: data

        !Private
        integer :: varid

        ! Check to make sure variable isn't already written. Exit if not.
        if (nf90_inq_varid(ncid = ncid, name = trim(varname), varid = varid) .eq. nf90_noerr) then 
           write(*,*) trim(varname), ' already written. Not re-writing.'
           return
        end if

        ! Put open file in define mode
        call handle_err(nf90_redef(ncid = ncid)) 

        ! Get varid
        call handle_err(nf90_def_var(ncid = ncid, name = varname, &
            xtype = nf90_float, dimids = dimid, varid = varid ) ) 

        ! Add attributes
        call handle_err(nf90_put_att(ncid, varid, 'units', units))
        call handle_err(nf90_put_att(ncid, varid, 'long_name', longname))
        call handle_err(nf90_enddef(ncid = ncid)) ! End define mode

        ! Write data
        call handle_err(nf90_put_var(ncid,varid,data))
        write(*,*) varname, " written to netCDF file."

     end subroutine write_netCDF1



      !============================!
      !  Subroutine write_netCDF3  !
      !                            !
      !  Write 3D field to given   !
      !  netCDF file               !
      !============================!

      subroutine write_netCDF3(ncid,dimids,varname,units,longname,data) 

        implicit none

        !In
        integer, intent(in) :: ncid 
        integer, dimension(3) :: dimids
        character(*), intent(in) :: varname, units, longname
        real, intent(in), dimension(:,:,:), allocatable :: data

        !Private
        integer :: varid

        ! Check to make sure variable isn't already written. Exit if not.
        if (nf90_inq_varid(ncid = ncid, name = trim(varname), varid = varid) .eq. nf90_noerr) then 
           write(*,*) trim(varname), ' already written. Not re-writing.'
           return
        end if

        ! Put open file in define mode
        call handle_err(nf90_redef(ncid = ncid)) 

        ! Get varid
        call handle_err(nf90_def_var(ncid = ncid, name = varname, &
            xtype = nf90_float, dimids = dimids, varid = varid ) ) 

        ! Add attributes
        call handle_err(nf90_put_att(ncid, varid, 'units', units))
        call handle_err(nf90_put_att(ncid, varid, 'long_name', longname))
        call handle_err(nf90_enddef(ncid = ncid)) ! End define mode

        ! Write data
        call handle_err(nf90_put_var(ncid,varid,data))
        write(*,*) varname, " written to netCDF file."

     end subroutine write_netCDF3

      !============================!
      !  Subroutine write_netCDF4  !
      !                            !
      !  Write 4D field to given   !
      !  netCDF file               !
      !============================!

      subroutine write_netCDF4(ncid,dimids,varname,units,longname,data) 

        implicit none

        !In
        integer, intent(in) :: ncid 
        integer, dimension(4) :: dimids
        character(*), intent(in) :: varname, units, longname
        real, intent(in), dimension(:,:,:,:), allocatable :: data

        !Private
        integer :: varid

        ! Check to make sure variable isn't already written. Exit if not.
        if (nf90_inq_varid(ncid = ncid, name = trim(varname), varid = varid) .eq. nf90_noerr) then 
           write(*,*) trim(varname), ' already written. Not re-writing.'
           return
        end if


        ! Put open file in define mode
        call handle_err(nf90_redef(ncid = ncid)) 

        ! Get varid
        call handle_err(nf90_def_var(ncid = ncid, name = varname, &
            xtype = nf90_float, dimids = dimids, varid = varid ) ) 

        ! Add attributes
        call handle_err(nf90_put_att(ncid, varid, 'units', units))
        call handle_err(nf90_put_att(ncid, varid, 'long_name', longname))
        call handle_err(nf90_enddef(ncid = ncid)) ! End define mode

        ! Write data
        call handle_err(nf90_put_var(ncid,varid,data))
        write(*,*) varname, " written to netCDF file."

     end subroutine write_netCDF4


      !==========================!
      !  Subroutine handle_err   !
      !                          !
      !  Define how to handle    !
      !  errors with netCDF      !
      !  files                   !
      !==========================!

      subroutine handle_err(status)

         implicit none

         ! In
         integer, intent(in) :: status

         if(status /= nf90_noerr) then
            print *, trim(nf90_strerror(status))
            call exit(-1)
         end if

      end subroutine handle_err

end module netcdf_mod

!     -------------------------------------------------------
!     Do a clustering of the events
!     -------------------------------------------------------

      subroutine clustering(outar,ntot,&
                 	    inar,xmin,ymin,dx,dy,nx,ny)

!     Given the input array <inar> with 0/1 entries (for example the
!     NCOFF array), the individual events are counted and each event
!     gets an individual 'stamp' which is specific to this event. An
!     event is characterised by 1-entries in <inar> which are connected.
!     <nx>,<ny> give the dimension of the arrays, <ntot> the total 
!     number of events. It is assumed that the domain is periodic in
!     x direction.

      IMPLICIT NONE
      
!     Declaration of subroutine parameters
      integer nx,ny
      real    inar (nx,ny)
      real    outar(nx,ny)
      integer ntot
      real    xmin,ymin,dx,dy
      
!     Auxiliary variables
      integer i,j
      integer tmpar(nx,ny)

!     Copy inar to outar
      do i=1,nx
         do j=1,ny
            tmpar(i,j)=nint(inar(i,j))
         enddo
      enddo
        
!     Do the clustering (based on simple connectivivity)
      do i=1,nx
      do j=1,ny

!        Find an element which does not yet belong to a cluster
         if (tmpar(i,j).eq.1) then ! etwas vorhanden, gehört aber noch nicht zu einem cluster
            ntot=ntot+1  ! ein event mehr
            tmpar(i,j)=ntot   ! tmpar ist Nummer des Events

            call connected(tmpar,ntot,i,j,xmin,ymin,dx,dy,nx,ny)

         endif

      enddo
      enddo

!     Correct the output array (so far, the index is 1 unit to large)
      do i=1,nx
         do j=1,ny
            if ( (nint(inar(i,j)).eq.1) ) then    
               outar(i,j)=real(tmpar(i,j))-1.
            endif
         enddo
      enddo

      ntot=ntot-1
         
      return
      
      END

!-----------------------------------------------------------------

      subroutine connected (outar,ntot,i,j,xmin,ymin,dx,dy,nx,ny)

!     Mark all elements in outar which are connected to element i,j

      implicit none

!     Declaration of subroutine parameters
      integer   nx,ny
      integer   ntot
      integer   i,j
      integer   outar(nx,ny)
      real      xmin,ymin,dx,dy

!     Numerical epsilon
      real      eps
      parameter (eps=0.01)

!     Auxiliary variables
      integer   il,ir,ju,jd,im,jm
      integer   k
      integer   stack,stack2
      integer   nmax
      integer   indx(nx*ny),indy(nx*ny)
      integer   northpole,southpole,periodic
      real      xmax,ymax

!     Get the topology of the grid
      xmax=xmin+real(nx-1)*dx
      ymax=ymin+real(ny-1)*dy
!      if ( abs(xmax-xmin-360.).lt.eps ) then
         periodic=1                            ! Periodic and closed
!      elseif ( abs(xmax-xmin-360.+dx).lt.eps) then
!         periodic=2                            ! Periodic, but not closed
!      else
!         periodic=0                            ! Not periodic
!      endif

!      if ( abs(ymin+90.).lt.eps) then
!         southpole=1                           ! South pole
!      elseif ( abs(ymin+90.-dy).lt.eps) then
!         southpole=2                           ! Near south pole
!      else
         southpole=0                           ! South pole is far away
!      endif
!      if ( abs(ymax-90.).lt.eps) then
!         northpole=1                           ! North pole
!      elseif ( abs(ymax-90.+dy).lt.eps) then
!         northpole=2                           ! Near north pole
!      else
         northpole=0                           ! North pole is far away
!      endif
	
!     Set maximum stack size
      nmax=nx*ny

!     Push the first element onto the stack
indx(:)=0
indy(:)=0
      stack=1 

      indx(stack)=i
      indy(stack)=j

!     Loop over all connected points
 100  continue


!     Get an element from the stack      
      im=indx(stack)
      jm=indy(stack)
      stack=stack-1    


      stack2=stack
      outar(im,jm)=ntot


!     Define the indices of the neighbouring elements
      il=im-1
      ir=im+1
      ju=jm+1
      jd=jm-1

!     Decide how to handle boundary points (depending on grid topology)
      if ( (il.eq.0).and.(periodic.ne.0) ) then
         il=nx
      endif
      if ( (ir.eq.(nx+1)).and.(periodic.ne.0) ) then
         ir=1
      endif
      if ( (jd.eq.0).and.(periodic.ne.0) ) then
         jd=ny
      endif
      if ( (ju.eq.(ny+1)).and.(periodic.ne.0) ) then
         ju=1
      endif
      
!     Check whether there is a stack overflow possible    
      if (stack.gt.(nmax-nx)) then

         print*,'Stack overflow in clustering'
         stop
      endif

!     Mark all connected elements (build up the stack)
!periodic in y      if ((ju.ne.(ny+1)).and.(jd.ne.0)) then


         if (outar(il,jm).eq.1) then
            outar(il,jm)=ntot
            stack=stack+1
            indx(stack)=il
            indy(stack)=jm
         endif
         if (outar(ir,jm).eq.1) then
            outar(ir,jm)=ntot
            stack=stack+1
            indx(stack)=ir
            indy(stack)=jm
         endif
         if (outar(im,ju).eq.1) then
            outar(im,ju)=ntot
            stack=stack+1
            indx(stack)=im
            indy(stack)=ju
         endif
         if (outar(im,jd).eq.1) then
            outar(im,jd)=ntot
            stack=stack+1
            indx(stack)=im
            indy(stack)=jd
         endif
         if (outar(il,jd).eq.1) then
            outar(il,jd)=ntot
            stack=stack+1
            indx(stack)=il
            indy(stack)=jd
         endif
         if (outar(il,ju).eq.1) then
            outar(il,ju)=ntot
            stack=stack+1
            indx(stack)=il
            indy(stack)=ju
         endif
         if (outar(ir,jd).eq.1) then
            outar(ir,jd)=ntot
            stack=stack+1
            indx(stack)=ir
            indy(stack)=jd
         endif
         if (outar(ir,ju).eq.1) then
            outar(ir,ju)=ntot
            stack=stack+1
            indx(stack)=ir
            indy(stack)=ju
         endif

!      else if (jd.eq.0) then
!          if (outar(il,jm).eq.1) then
!            outar(il,jm)=ntot
!            stack=stack+1
!            indx(stack)=il
!            indy(stack)=jm
!         endif
!         if (outar(ir,jm).eq.1) then
!            outar(ir,jm)=ntot
!            stack=stack+1
!            indx(stack)=ir
!            indy(stack)=jm
!         endif
!         if (outar(im,ju).eq.1) then
!            outar(im,ju)=ntot
!            stack=stack+1
!            indx(stack)=im
!            indy(stack)=ju
!         endif
!         if (outar(il,ju).eq.1) then
!            outar(il,ju)=ntot
!            stack=stack+1
!            indx(stack)=il
!            indy(stack)=ju
!         endif
!         if (outar(ir,ju).eq.1) then
!            outar(ir,ju)=ntot
!            stack=stack+1
!            indx(stack)=ir
!            indy(stack)=ju
!         endif   
!         if (southpole.ne.0) then
!           do k=1,nx
!              if (outar(k,jm).ne.ntot) then
!                outar(k,jm)=ntot
!                stack=stack+1
!                indx(stack)=k
!                indy(stack)=jm
!              endif
!           enddo
!         endif
!         
!      else if (ju.eq.(ny+1)) then
!         if (outar(il,jm).eq.1) then
!            outar(il,jm)=ntot
!            stack=stack+1
!            indx(stack)=il
!            indy(stack)=jm
!         endif
!         if (outar(ir,jm).eq.1) then
!            outar(ir,jm)=ntot
!            stack=stack+1
!            indx(stack)=ir
!            indy(stack)=jm
!         endif
!         if (outar(im,jd).eq.1) then
!            outar(im,jd)=ntot
!            stack=stack+1
!            indx(stack)=im
!            indy(stack)=jd
!         endif
!         if (outar(il,jd).eq.1) then
!            outar(il,jd)=ntot
!            stack=stack+1
!            indx(stack)=il
!            indy(stack)=jd
!         endif
!         if (outar(ir,jd).eq.1) then
!            outar(ir,jd)=ntot
!            stack=stack+1
!            indx(stack)=ir
!            indy(stack)=jd
!         endif
!         if (northpole.ne.0) then
!           do k=1,nx
!              if (outar(k,jm).ne.ntot) then
!                outar(k,jm)=ntot
!                stack=stack+1
!                indx(stack)=k
!                indy(stack)=jm
!              endif
!           enddo
!         endif
!           
!      endif

 200  continue

     if (stack.gt.0) goto 100
 
      end
            

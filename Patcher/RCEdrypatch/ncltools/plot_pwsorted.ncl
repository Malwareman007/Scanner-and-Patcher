load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

fildir="/global/scratch/langhans/"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; set time vector for analysis
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
plt_times=fspan(1.,120.,120)

file2D=fildir+"/OUT_2D/"+"/RCE_4km_128x128x96_4km_10s_305K_EDMF_tn300_64.2Dcom_1.nc"

f=addfile(file2D,"r")
PW2D=f->PW(1:239:2,:,:)
time=f->time(1:239:2)
pwquarts=new((/3,dimsizes(time)/),float)
opt=False
do i=0,dimsizes(time)-1
  stat = stat_dispersion(PW2D(i,:,:), opt )
  pwquarts(0,i) = stat(6)  ; 25%
  pwquarts(1,i) = stat(8)  ; 50%
  pwquarts(2,i) = stat(10) ; 75%
end do

fileSTAT=fildir+"/OUT_STAT/"+"RCE_4km_128x128x96_4km_10s_305K_EDMF_tn300.nc" 
f=addfile(fileSTAT,"r")
RHO=f->RHO(11:1439:12,:)

do i=0,dimsizes(time)-1

navg=1

do j=0,navg-1


strg=sprinti("%0.10i",floattointeger(time(i)*24.*3600./10.+(j-(navg-1)/2)*1080.))
file3D=fildir+"/OUT_3D/"+"RCE_4km_128x128x96_4km_10s_305K_EDMF_tn300_64_"+strg+".nc" 
f=addfile(file3D,"r")
if (i.eq.0.and.j.eq.0) then
  z=f->z
  rhavg = new((/dimsizes(time),dimsizes(z),4/),float)
  rhavg!0    = "time"
  rhavg&time = time
  rhavg!1    = "z"
  rhavg&z = z
  rhavg!2    = "quartile"
  rhavg&quartile = (/1.,2.,3.,4./)
  rhavg=0.

  qtfluxsavg = new((/dimsizes(time),dimsizes(z),4/),float)
  qtfluxsavg!0    = "time"
  qtfluxsavg&time = time
  qtfluxsavg!1    = "z"
  qtfluxsavg&z = z
  qtfluxsavg!2    = "quartile"
  qtfluxsavg&quartile = (/1.,2.,3.,4./)
  qtfluxsavg=0.

  qtfluxravg = new((/dimsizes(time),dimsizes(z),4/),float)
  qtfluxravg!0    = "time"
  qtfluxravg&time = time
  qtfluxravg!1    = "z"
  qtfluxravg&z = z
  qtfluxravg!2    = "quartile"
  qtfluxravg&quartile = (/1.,2.,3.,4./)
  qtfluxravg=0.
end if


T3D=f->TABS
QV3D=f->QV
QV3D=QV3D/1000.
P3D=f->PP   ; Pa
P3D=P3D/100.;hPa
W3D =f->W
QN3D=f->QN 
QN3D=QN3D/1000.
do k=0,dimsizes(z)-1
  P3D(0,k,:,:) = P3D(0,k,:,:) + f->p(k)
end do
THL3D= (1000./P3D)^(287./1005.)*(T3D - 2.5e6/1005.*QN3D)

P3D=P3D*100. ; Pa

RH3D = relhum(T3D,QV3D,P3D)
QTFLUXS3D = f->QTFLUXMF + f->QTFLUXED
;QTFLUXS3D = f->QTFLUXED

do k=0,dimsizes(z)-1
  hlp=where(PW2D(i,:,:).lt.pwquarts(0,i),RH3D(0,k,:,:),-999.)
  hlp@_FillValue=-999.
  rhavg(i,k,0) =rhavg(i,k,0)+avg(hlp) 
  hlp=where(PW2D(i,:,:).ge.pwquarts(0,i).and.PW2D(i,:,:).lt.pwquarts(1,i),RH3D(0,k,:,:),-999.)
  hlp@_FillValue=-999.
  rhavg(i,k,1) =rhavg(i,k,1)+avg(hlp) 
  hlp=where(PW2D(i,:,:).ge.pwquarts(1,i).and.PW2D(i,:,:).lt.pwquarts(2,i),RH3D(0,k,:,:),-999.)
  hlp@_FillValue=-999.
  rhavg(i,k,2) =rhavg(i,k,2)+avg(hlp) 
  hlp=where(PW2D(i,:,:).ge.pwquarts(2,i),RH3D(0,k,:,:),-999.)
  hlp@_FillValue=-999.
  rhavg(i,k,3) =rhavg(i,k,3)+avg(hlp) 

  hlp=where(PW2D(i,:,:).lt.pwquarts(0,i),QTFLUXS3D(0,k,:,:),-999.)
  hlp@_FillValue=-999.
  qtfluxsavg(i,k,0) =qtfluxsavg(i,k,0)+avg(hlp) 
  hlp=where(PW2D(i,:,:).ge.pwquarts(0,i).and.PW2D(i,:,:).lt.pwquarts(1,i),QTFLUXS3D(0,k,:,:),-999.)
  hlp@_FillValue=-999.
  qtfluxsavg(i,k,1) =qtfluxsavg(i,k,1)+avg(hlp) 
  hlp=where(PW2D(i,:,:).ge.pwquarts(1,i).and.PW2D(i,:,:).lt.pwquarts(2,i),QTFLUXS3D(0,k,:,:),-999.)
  hlp@_FillValue=-999.
  qtfluxsavg(i,k,2) =qtfluxsavg(i,k,2)+avg(hlp) 
  hlp=where(PW2D(i,:,:).ge.pwquarts(2,i),QTFLUXS3D(0,k,:,:),-999.)
  hlp@_FillValue=-999.
  qtfluxsavg(i,k,3) =qtfluxsavg(i,k,3)+avg(hlp) * RHO(i,k) * (3600.*24.) ; kg/m2/day
  

  kb=max((/1,k-1/))
  flux=where(W3D(0,k,:,:).gt.0.0,W3D(0,k,:,:)*(QV3D(0,kb,:,:)+QN3D(0,kb,:,:)),W3D(0,k,:,:)*(QV3D(0,k,:,:)+QN3D(0,k,:,:)))
  hlp=where(PW2D(i,:,:).lt.pwquarts(0,i),flux,-999.)
  hlp@_FillValue=-999.
  qtfluxravg(i,k,0) =qtfluxravg(i,k,0)+avg(hlp)
  hlp=where(PW2D(i,:,:).ge.pwquarts(0,i).and.PW2D(i,:,:).lt.pwquarts(1,i),flux,-999.)
  hlp@_FillValue=-999.
  qtfluxravg(i,k,1) =qtfluxravg(i,k,1)+avg(hlp) 
  hlp=where(PW2D(i,:,:).ge.pwquarts(1,i).and.PW2D(i,:,:).lt.pwquarts(2,i),flux,-999.)
  hlp@_FillValue=-999.
  qtfluxravg(i,k,2) =qtfluxravg(i,k,2)+avg(hlp) 
  hlp=where(PW2D(i,:,:).ge.pwquarts(2,i),flux,-999.)
  hlp@_FillValue=-999.
  qtfluxravg(i,k,3) =qtfluxravg(i,k,3)+avg(hlp) * RHO(i,k) * (3600.*24.) ; kg/m2/day
  

  delete(hlp)
end do ; k

end do ; j

rhavg(i,:,:)=rhavg(i,:,:)/navg
qtfluxravg(i,:,:)=qtfluxravg(i,:,:)/navg
qtfluxsavg(i,:,:)=qtfluxsavg(i,:,:)/navg

end do ; i


  wks  = gsn_open_wks("eps","rhavg")   ; send graphics to PNG file
  gsn_define_colormap(wks,"MPL_PuBu")

  res                     = True          ; plot mods desired
  res@gsnDraw = False
  res@gsnFrame = False

  res@cnFillOn            = True          ; turn on color
  res@cnLinesOn           = False
  res@cnFillPalette       = "gui_default" ; set color map
 
  ;res@vpWidthF            = 0.5           ; change aspect ratio of plot
  ;res@vpHeightF           = 0.3
  res@gsnYAxisIrregular2Linear = True
  res@trYMaxF = 22000.
  ;res@trXMaxF = 40.
 
  res@cnLevelSelectionMode =  "ManualLevels"
  ;rh
  res@cnMinLevelValF       = 5.00
  res@cnMaxLevelValF       = 95.0
  res@cnLevelSpacingF      = 5.0
  ;qtfluxs
  ;res@cnMinLevelValF       = 0.25
  ;res@cnMaxLevelValF       = 3.5
  ;res@cnLevelSpacingF      = 0.25
  

  res@tiYAxisString        = "Height (m)"
  res@tiXAxisString        = "Time (days)"
  ;res@gsnMaximize         = True          ; maximize plot size
  res@lbOrientation       = "vertical"

  plot=new(4,graphic)
  plot(0) = gsn_csm_contour(wks,rhavg(z|:,time|:,quartile|0),res)       ; contour the variable
  plot(1) = gsn_csm_contour(wks,rhavg(z|:,time|:,quartile|1),res)       ; contour the variable
  plot(2) = gsn_csm_contour(wks,rhavg(z|:,time|:,quartile|2),res)       ; contour the variable
  plot(3) = gsn_csm_contour(wks,rhavg(z|:,time|:,quartile|3),res)       ; contour the variable



  gsn_panel(wks,plot,(/2,2/),False)




;end of ncl script
end 




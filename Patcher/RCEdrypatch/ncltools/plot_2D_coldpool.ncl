load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

fildir="/global/scratch/langhans/"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; set time vector for analysis
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
plt_time=hour/24.

file2D=fildir+"/OUT_2D/"+"/"+rname+"_64.2Dcom_1.nc"

f=addfile(file2D,"r")
time=f->time-34.
indtime=ind(abs(time-plt_time).eq.min(abs(time-plt_time)))
PW2D=f->PW(indtime,:,:)
PW2D!0 = "x"
PW2D!1 = "y"
PW2D&x = f->x
PW2D&y = f->y
PW2D@long_name="34 d " + sprintf("%3.1f",hour)+ " h"
LHF=f->LHF(indtime,:,:)
SHF=f->SHF(indtime,:,:)
dims=dimsizes(SHF)
USFC = f->USFC(indtime,:,:)
VSFC = f->VSFC(indtime,:,:)
UMAG=USFC
UMAG(0:dims(0)-2,0:dims(1)-2)=0.25 * (USFC(0:dims(0)-2,0:dims(1)-2) + USFC(0:dims(0)-2,1:dims(1)-1))^2. + \
     0.25 * (VSFC(0:dims(0)-2,0:dims(1)-2) + VSFC(1:dims(0)-1,0:dims(1)-2))^2.
UMAG(dims(0)-1,0:dims(1)-2) =  0.25 * (USFC(dims(0)-1,0:dims(1)-2) + USFC(dims(0)-1,1:dims(1)-1))^2.  + \
                        0.25 * (VSFC(dims(0)-1,0:dims(1)-2) + VSFC(0,0:dims(1)-2))^2.
UMAG(0:dims(0)-2,dims(1)-1) =  0.25 * (USFC(0:dims(0)-2,dims(1)-1) + USFC(0:dims(0)-2,0))^2.  + \
                        0.25 * (VSFC(0:dims(0)-2,dims(1)-1) + VSFC(1:dims(0)-1,dims(1)-1))^2.
UMAG(dims(0)-1,dims(1)-1) = 0.25 * (USFC(dims(0)-1,dims(1)-1) + USFC(dims(0)-1,0))^2.  + \
                        0.25 * (VSFC(dims(0)-1,dims(1)-1) + VSFC(0,dims(1)-1))^2.


UMAG=sqrt(UMAG)

strg=sprinti("%0.10i",floattointeger(plt_time*24.*3600./10.))
file3D=fildir+"/OUT_3D/"+rname+"_64_"+strg+".nc" 
print(file3D)
f=addfile(file3D,"r")
z=f->z
T3D=f->TABS(0,:,:,:)
QV3D=f->QV(0,:,:,:)
QV3D=QV3D/1000.
P3D=f->PP(0,:,:,:)   ; Pa
P3D=P3D/100.;hPa
W3D =f->W(0,:,:,:)
QN3D=f->QN(0,:,:,:) 
QN3D=QN3D/1000.
QP3D=f->QP(0,:,:,:) 
QP3D=QP3D/1000.
do k=0,dimsizes(z)-1
  P3D(k,:,:) = P3D(k,:,:) + f->p(k)
end do
THV3D= T3D*(1000./P3D)^(287./1005.)*(1. + 0.61 * QV3D - QN3D - QP3D)

P3D=P3D*100. ; Pa



;THV2Davg = dim_avg_n(THV3D(0:8,:,:),0)
THV2Davg = dim_avg_n(THV3D(0:4,:,:),0)
THV2Davg!0 = "x"
THV2Davg!1 = "y"
THV2Davg&x = f->x
THV2Davg&y = f->y
UMAG!0 = "x"
UMAG!1 = "y"
UMAG&x = f->x
UMAG&y = f->y
UMAG@long_name="34 d " + sprintf("%3.1f",hour)+ " h"
delete(UMAG@units)

THV2Davg = THV2Davg - avg(THV2Davg)
;THV2Davg=where(UMAG.lt.1.5,-999.,THV2Davg)
;THV2Davg=where(THV2Davg.gt.-.75,-999.,THV2Davg)
;THV2Davg=where(((THV2Davg.gt. -.75) .or. (UMAG.lt.1.5)),-999.,THV2Davg)
;THV2Davg@_FillValue=-999.

  wks  = gsn_open_wks("eps","PW2D_edmffalse_ctketau_350_"+strg)   ; send graphics to PNG file
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
  ;res@trYMaxF = 22000.
  ;res@trXMaxF = 40.
 
  res@cnLevelSelectionMode =  "ManualLevels"
  ;rh
  ;res@cnMinLevelValF       = 5.00
  ;res@cnMaxLevelValF       = 95.0
  ;res@cnLevelSpacingF      = 5.0
  ;qtfluxs
  ;res@cnMinLevelValF       = 0.25
  ;res@cnMaxLevelValF       = 3.5
  ;res@cnLevelSpacingF      = 0.25
  res@cnLevelSelectionMode =  "ManualLevels"
  ; PW
  res@cnMinLevelValF       = 40.00
  res@cnMaxLevelValF       = 70.
  res@cnLevelSpacingF      = 2.5
  ; thv prime
  ;res@cnMinLevelValF       = -4.00
  ;res@cnMaxLevelValF       = 1.0
  ;res@cnLevelSpacingF      = 0.25
  

  res@tiYAxisString        = "Y (m)"
  res@tiXAxisString        = "X (m)"
  ;res@gsnMaximize         = True          ; maximize plot size
  res@lbOrientation       = "vertical"

  plot=new(4,graphic)
  res@cnFillMode = "RasterFill"
  plot(0) = gsn_csm_contour(wks,PW2D,res)       ; contour the variable


  res@cnFillOn            = False         ; turn on color
  res@cnLinesOn           = True
  res@cnLevelSelectionMode =  "ManualLevels"
  res@cnMinLevelValF       = 1.00
  res@cnMaxLevelValF       = 15.0
  res@cnLevelSpacingF      = 2.0
  res@cnLineLabelsOn       = False

  plot(1) = gsn_csm_contour(wks,UMAG,res)       ; contour the variable
  ;overlay(plot(0),plot(1))


  draw(plot(0))
  frame(wks)




;end of ncl script
end 




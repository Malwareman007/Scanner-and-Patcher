load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

fildir="/global/scratch/langhans/"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; set time vector for analysis
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

file2D=fildir+"/OUT_2D/"+"/RCE_4km_128x128x96_4km_10s_305K_EDMF_doedmffalse_tau16_64.2Dcom_1.nc"

f=addfile(file2D,"r")
hlp=f->time
dimstime=dimsizes(hlp)
delete(hlp)
USFC=f->USFC(1:dimstime-1:2,:,:)
VSFC=f->VSFC(1:dimstime-1:2,:,:)
LHF=f->LHF(1:dimstime-1:2,:,:)
time=f->time(1:dimstime-1:2)
dims=dimsizes(USFC)
UMAG=new((/dims(0),dims(1)-1,dims(2)-1/),float)
opt=False
UMAG=0.25 * (USFC(:,0:dims(1)-2,0:dims(2)-2) + USFC(:,0:dims(1)-2,1:dims(2)-1))^2. + \
     0.25 * (VSFC(:,0:dims(1)-2,0:dims(2)-2) + VSFC(:,1:dims(1)-1,0:dims(2)-2))^2.
UMAG=sqrt(UMAG)
umagstat=new((/dims(0),3/),float)
umagstat!0    = "time"
umagstat&time = time
umagstat!1    = "quartile"
umagstat&quartile= (/1.,2.,3./)
lhfstat=new((/dims(0),3/),float)
lhfstat!0    = "time"
lhfstat&time = time
lhfstat!1    = "quartile"
lhfstat&quartile= (/1.,2.,3./)

do i=0,dimsizes(time)-1
  stat = stat_dispersion(UMAG(i,:,:), opt )
  umagstat(i,0) = (/stat(10)/)  ; 75%
  umagstat(i,1) = (/stat(8)/)  ; 50%
  umagstat(i,2) = (/stat(13)/) ; 90%
  stat = stat_dispersion(LHF(i,:,:), opt )
  lhfstat(i,0) = (/stat(10)/)  ; 75%
  lhfstat(i,1) = (/stat(8)/)  ; 50%
  lhfstat(i,2) = (/stat(13)/) ; 90%
end do


  wks  = gsn_open_wks("eps","lhfstat")   ; send graphics to PNG file
  gsn_define_colormap(wks,"MPL_PuBu")

 res                   = True                       ; plot mods desired
 res@gsnFrame = False
 res@gsnDraw  = False
 res@xyMonoDashPattern=False
 res@vpHeightF = 0.5
; res@tiMainString      = "Potential temperature"             ; add title
 res@xyMonoLineColor=False
 res@xyLineColors = (/"red","black","deeppink2","blue","darkgreen"/)
 res@xyDashPatterns = (/1,0,1/)
 res@xyLineThicknessF = 6.
 ;res@vpWidthF=0.4
 res@trYMinF=40.; 0.
 res@trYMaxF=180. ;4.; max(umagstat)
 res@trYMinF=0.; 0.
 res@trYMaxF=4.; max(umagstat)
 res@trXMinF=0.
 res@trXMaxF=max(time)
 ;res@trXMinF=-50.
 ;res@trXMaxF=20.
 ;res@tiYAxisString = "latent heat flux (W m!S!-2!N!)" ;"wind speed (m s!S!-1!N!)"
 res@tiYAxisString = "wind speed (m s!S!-1!N!)"
 res@tiXAxisString = "time (days)"
 ;res@tiXAxisString = "!F8!r!F!c!B!p!N! <w'!F8!q!F!!B!l!N!'> (W m!S!-2!N!)"
 res@pmLegendDisplayMode    = "Never"
 res@xyExplicitLegendLabels = (/"tot","res","ed","mf"/)
 res@pmLegendWidthF         = 0.12                ; Change width and
 res@pmLegendHeightF        = 0.18
 res@pmLegendSide           = "Bottom"               ; Change location of
 res@pmLegendParallelPosF   = .85             ; move units right
 res@pmLegendOrthogonalPosF =   -1.2
 res@lgPerimOn              = False

 plot  = gsn_csm_xy (wks,time,umagstat(quartile|:,time|:),res)

 draw(plot)
 frame(wks)


;end of ncl script
end 




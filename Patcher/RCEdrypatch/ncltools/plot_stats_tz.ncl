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

fileSTAT=fildir+"/OUT_STAT/"+"Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_dosgscloudfalse.nc" 
f=addfile(fileSTAT,"r")
time=f->time
z=f->z
time2D=new((/dimsizes(time),dimsizes(z)/),float)
time2D=conform(time2D,time,0)
RHO=f->RHO
QTFLUXR=f->QTFLUX
QTFLUXS=f->QTFLUXS
;QTFLUXSM=f->QTFLUXSM
QTFLUXR=QTFLUXR-QTFLUXS;-QTFLUXSM
MC=f->MC
MCUP=f->MCUP
MCDNS=f->MCDNS
MCDNU=f->MCDNU

qtfluxavg=new((/dimsizes(z),4/),float)
qtfluxavg!0    = "height"
qtfluxavg&height = z
qtfluxavg!1    = "type"
qtfluxavg&type = (/1.,2.,3.,4./)
qtfluxavg=0.

mcavg=new((/dimsizes(z),4/),float)
mcavg!0    = "height"
mcavg&height = z
mcavg!1    = "type"
mcavg&type = (/1.,2.,3.,4./)
mcavg=0.


tb = 34.
te = 36.
hlp = where(time2D.gt.tb.and.time2D.le.te,QTFLUXR,-999.)
hlp@_FillValue=-999.
qtfluxavg(:,1) = dim_avg_n(hlp,0)

hlp = where(time2D.gt.tb.and.time2D.le.te,QTFLUXS,-999.)
hlp@_FillValue=-999.
qtfluxavg(:,2) = dim_avg_n(hlp,0)

;hlp = where(time2D.gt.tb.and.time2D.le.te,QTFLUXSM,-999.)
;hlp@_FillValue=-999.
;qtfluxavg(:,3) = dim_avg_n(hlp,0)

qtfluxavg(:,0)=qtfluxavg(:,1)+qtfluxavg(:,2)+qtfluxavg(:,3)

hlp = where(time2D.gt.tb.and.time2D.le.te,MCUP,-999.)
hlp@_FillValue=-999.
mcavg(:,1) = dim_avg_n(hlp,0)
hlp = where(time2D.gt.tb.and.time2D.le.te,MCDNU,-999.)
hlp@_FillValue=-999.
mcavg(:,2) = dim_avg_n(hlp,0)
hlp = where(time2D.gt.tb.and.time2D.le.te,MCDNS,-999.)
hlp@_FillValue=-999.
mcavg(:,3) = dim_avg_n(hlp,0)
mcavg(:,0) = mcavg(:,1) + mcavg(:,2)  + mcavg(:,3) 

  wks  = gsn_open_wks("eps","mc_profile")   ; send graphics to PNG file
  gsn_define_colormap(wks,"MPL_PuBu")

  

   res                   = True                       ; plot mods desired
 res@gsnFrame = False
 res@gsnDraw  = False
 res@xyMonoDashPattern=True
 res@vpHeightF = 0.5
; res@tiMainString      = "Potential temperature"             ; add title
 res@xyMonoLineColor=False
 res@xyLineColors = (/"black","red","blue","darkgreen"/) 
 res@xyLineThicknessF = 6.
 ;res@vpWidthF=0.4
 res@trYMinF=0.
 res@trYMaxF=16000.
 res@trXMinF=-30.
 res@trXMaxF=150.
 res@trXMinF=-0.02
 res@trXMaxF=0.02
 res@tiYAxisString = "z (m)"
 ;res@tiXAxisString = "!F8!r!F!L!B!v!N! <w'q!B!t!N!'> (W m!S!-2!N!)"
 res@tiXAxisString = "mass flux (kg/m2/s)"
 ;res@tiXAxisString = "!F8!r!F!c!B!p!N! <w'!F8!q!F!!B!l!N!'> (W m!S!-2!N!)"
 res@pmLegendDisplayMode    = "Always"
 ;res@xyExplicitLegendLabels = (/"tot","res","ed","mf"/)
 res@xyExplicitLegendLabels = (/"tot","up","dnu","dns"/)
 res@pmLegendWidthF         = 0.12                ; Change width and
 res@pmLegendHeightF        = 0.18
 res@pmLegendSide           = "Bottom"               ; Change location of
 res@pmLegendParallelPosF   = .85             ; move units right
 res@pmLegendOrthogonalPosF =   -1.2 
 res@lgPerimOn              = False

 plot  = gsn_csm_xy (wks,mcavg(type|:,height|:),z,res)

 draw(plot)
 frame(wks)


;end of ncl script
end 




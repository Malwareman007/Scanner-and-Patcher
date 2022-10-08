load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

fildir="/global/scratch/langhans/"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; set time vector for analysis
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

files2D=(/"Case1_128x128x96_4km_10s_305K_TKE_case1_293760_seed0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_seed1_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_seed2_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_seed3_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_SFChomo_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_SFChomo_seed0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_SFChomo_seed1_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_SFChomo_seed2_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_SFChomoqvonly_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_SFChomoqvonly_seed0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_tkvfac_5_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_tkvfac_10_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_mff_ctketau_d20m700b2km_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_dosgscloudfalse_64.2Dcom_1.nc"/);,"Case1_128x128x96_4km_10s_305K_TKE_case1_293760_radnoqc_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_radnoqc_seed0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_radnoqc_seed1_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_radnoqi_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_radnoqi_seed0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_radnoqi_seed1_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_radnoqiqc_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_radnoqiqc_seed0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_radnoqiqc_seed1_64.2Dcom_1.nc"/)


;Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_dosgscloudfalse_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_ctketau_350_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_ctketau_175_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_ctketau_80_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_ctketau_60_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_ctketau_50_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_ctketau_20_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_ctketau_0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_SFChomo_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_SFChomo_seed0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_SFChomo_seed1_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_SFChomo_seed2_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_SFChomoqvonly_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_SFChomoqvonly_seed0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_ctketau_20_a3475_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_ctketau_700_a3475_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_ctketau_700_SFChomoqvonly_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_ctketau_700_SFCqo_seed0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_ctketau_700_SFCqo_seed1_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_ctketau_350_SFCqo_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_ctketau_350_SFCqo_seed0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_ctketau_350_SFCqo_seed1_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_mff_ctketau_700_tk0a2km_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_mff_ctketau_700_tk0b2km_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_mff_ctketau_700_tk0a4km_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_mff_ctketau_700_tk0b4km_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_mff_ctketau_700_tk0b5km_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_mff_ctketau_700_tk0b6km_64.2Dcom_1.nc"/);"Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o7_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_seed0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_seed1_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_seed2_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_seed3_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o1_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o2_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o3_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o4_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o5_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o6_64.2Dcom_1.nc"/)
;files2D=(/"Case1_128x128x96_4km_10s_305K_TKE_case1_293760_seed0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_dosgscloudfalse_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_mff_ctketau_m20d700_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_mff_ctketau_d20m700_64.2Dcom_1.nc"/)

;files2D=(/"Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o1_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o1_seed0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o1_seed1_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o2_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o2_seed0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o2_seed1_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o3_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o3_seed0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o3_seed1_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o4_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o4_seed0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o4_seed1_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o5_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o5_seed0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o5_seed1_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o6_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o6_seed0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o6_seed1_64.2Dcom_1.nc"/)

;files2D=(/"Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o4_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o4_seed0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o4_seed1_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o5_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o5_seed0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o5_seed1_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o6_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o6_seed0_64.2Dcom_1.nc","Case1_128x128x96_4km_10s_305K_TKE_case1_293760_LWhomo_o6_seed1_64.2Dcom_1.nc"/)


;colors=(/"gray","gray","gray","gray","gray","black","black","black","black","black","black","blue","red","darkgreen","orange","maroon1","green"/)
;colors=(/"blue","blue","blue","red","red","red","darkgreen","darkgreen","darkgreen","orange","orange","orange","maroon1","maroon1","maroon1","green","green","green"/)
;colors=(/"orange","orange","orange","maroon1","maroon1","maroon1","green","green","green"/)
;colors=(/"black","black","black","black","black","blue","red","maroon4","antiquewhite3","coral","blue4","orange","darkgreen","gray","gray","gray","gray","springgreen2","springgreen2","greenyellow","yellow","blue","blue","blue","red","red","red","maroon4","blue4","maroon4","blue4","blue4","blue4","blue4"/)
colors=(/"black","black","black","black","black","blue","blue","blue","blue","red","red","darkgreen","orange","yellow","purple","gray","gray","gray","brown","brown","brown","purple","purple","purple"/)
dashes=(/0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,1,2,3,1,5,2,1,2,3,4/)
;legend = (/"ref","ref","ref","ref","ref","all-sky up and down","all-sky up and down","all-sky up and down","all-sky up and down","all-sky up and down","all-sky up and down","clear up","cloud up","all-sky up","clear down","cloud down","all-sky down"/)
;legend = (/"clear up","clear up","clear up","cloud up","cloud up","cloud up","all-sky up","all-sky up","all-sky up","clear down","clear down","clear down","cloud down","cloud down","cloud down","all-sky down","all-sky down","all-sky down"/)
;legend = (/"clear down","clear down","clear down","cloud down","cloud down","cloud down","all-sky down","all-sky down","all-sky down"/)
;legend = (/"TKE","TKE","TKE","TKE","TKE","NP tau=700","NP tau=350","NP tau=175","NP tau=80","NP tau=60","NP tau=50","NP tau=20","NP tau=0","TKE sfchomo","TKE sfchomo","TKE sfchomo","TKE sfchomo","TKE sfchomo qv","TKE sfchomo qv","NP 20 after","NP 700 after","NP tau=700 sfchomo qv","NP tau=700 sfchomo qv","NP tau=700 sfchomo qv","NP tau=700 sfchomo qv","NP tau=700 sfchomo qv","NP tau=700 sfchomo qv","NP tau=700 <2km","NP tau=700 >2km","NP tau=700 <4km","NP tau=700 >4km","NP tau=700 >5km","NP tau=700 >6km"/)
legend=(/"TKE","TKE","TKE","TKE","TKE","TKE sfc homo","TKE sfc homo","TKE sfc homo","TKE sfc homo","TKE sfc qv homo","TKE sfc qv homo","TKE fac 5","TKE fac 10","700 moist&<2km","700","rad qc=0","rad qc=0","rad qc=0","rad qi=0","rad qi=0","rad qi=0","rad qiqc=0","rad qiqc=0","rad qiqc=0"/)

plot=new(dimsizes(files2D),graphic)
dum = new(dimsizes(files2D),graphic)

nl=0
do n=0,dimsizes(files2D)-1

f=addfile(fildir+"/OUT_2D/"+files2D(n),"r")
hlp=f->time
dimstime=dimsizes(hlp)
delete(hlp)
PW=f->PW
LHF=f->LHF
dims=dimsizes(PW)
time=f->time
;time(0:dimstime-2)=0.5*(time(0:dimstime-2) + time(1:dimstime-1))
;pwstat=new((/dimstime,5/),float)
;pwstat!0    = "time"
;pwstat&time = time
;pwstat!1    = "quartile"
;pwstat&quartile= (/1.,2.,3.,4.,5./)
;opt=False
;
;do i=0,dimsizes(time)-1
;  stat = stat_dispersion(PW(i,:,:), opt )
;  pwstat(i,0) = (/stat(0)/)  ; mean
;  pwstat(i,1) = (/stat(1)/)  ; std
;  pwstat(i,2) = (/stat(2)/) ; min
;  pwstat(i,3) = (/stat(23)/) ; lower 1%
;  pwstat(i,4) = (/stat(24)/) ; lower 5%
;end do

;pwstat(:,1) = pwstat(:,0) - 2.* pwstat(:,1) ; mean minus twice std
;tmp=pwstat(:,1)
;tmp=where(time.lt.20..or.time.gt.35.,-999.,tmp)
;tmp@_FillValue=-999.
;pwcrit=avg(tmp)  ; time average
pwcrit=54.
;delete(tmp)
;print(pwcrit)

fpw=time
lhf=fpw
do i=0,dimstime-1
  tmp = where(PW(i,:,:).lt.pwcrit,pwcrit-PW(i,:,:),0.0)
  fpw(i)=sum(tmp)
  tmp = where(PW(i,:,:).lt.pwcrit,LHF(i,:,:),-999.)
  tmp@_FillValue=-999.
  lhf(i)=avg(tmp)
end do
delete(tmp)
fpw=fpw/(dims(1)*dims(2))/pwcrit
fpw= runave_n(fpw, 9, 0, 0)
lhf= runave_n(lhf, 9, 0, 0)

  if (n.eq.0) then
  wks  = gsn_open_wks("eps","lhf_timeseries_edmf")   ; send graphics to PNG file
  gsn_define_colormap(wks,"MPL_PuBu")

 res                   = True                       ; plot mods desired
 res@gsnFrame = False
 res@gsnDraw  = False
 res@xyMonoDashPattern=True
 res@vpHeightF = 0.5
 res@xyMonoLineColor=True
 res@xyLineColors = (/"red","black","deeppink2","blue","blue"/)
 res@xyDashPatterns = (/1,0,1/)
 res@xyLineThicknessF = 2.
 ;res@vpWidthF=0.4
 res@trYMinF=0.; 0.
 res@trYMaxF=.004 ;4.; max(umagstat)
 res@trYMinF=100.; 0.
 res@trYMaxF=130.00 ;4.; max(umagstat)
 ;res@trYMinF=0.; 0.
 ;res@trYMaxF=100.00 ;4.; max(umagstat)
 res@trXMinF=34.;min(time)
 res@trXMaxF=38. ; max(time)
 ;res@trXMaxF= max(time)
 ;res@tiYAxisString = "latent heat flux (W m!S!-2!N!)" ;"wind speed (m s!S!-1!N!)"
 res@tiYAxisString = "Fpw"
 res@tiYAxisString = "LHF (W m!S!-2!N!)"
 res@tiXAxisString = "time (days)"
 res@pmLegendWidthF         = 0.12           ; Change width and
 res@pmLegendHeightF        = 0.24
 res@pmLegendSide           = "Top"               ; Change location of
 res@lgJustification = "BottomLeft"
 res@lgPerimOn              =False 
 res@lgLabelFontHeightF = 0.02
 res@pmLegendParallelPosF =   0.02 

 end if
 ;if (n.ge.5.or.n.eq.0) then
 ;if (n.eq.0.or.n.eq.5) then
 ;if (mod(n,3).eq.0) then
 res@pmLegendDisplayMode    = "Always"
 res@pmLegendOrthogonalPosF =  -0.32 -  nl*0.04
 nl=nl+1
 ;else
 ;res@pmLegendDisplayMode    = "Never"
 ;end if

 res@xyLineColor =  colors(n)
 res@xyDashPattern = dashes(n)
 res@xyExplicitLegendLabels = legend(n)
 ;res@xyExplicitLegendLabels = (/"mean","mean-2!F8!s!F!","min","1%","5%"/)

 ;plot(n)  = gsn_csm_xy (wks,time,pwstat(quartile|:,time|:),res)
 print("Plotting numer "+ n)
 plot(n)  = gsn_csm_xy (wks,time,lhf,res)
 pmres = True
 pmres@gsMarkerColor = colors(n)
 pmres@gsMarkerIndex = 16-dashes(n)
 pmres@gsMarkerSizeF=0.005
 xmarkers=37.
 tmp=where(time.gt.38.or.time.le.34.0,-999.,lhf)
 tmp@_FillValue=-999.
 ymarkers=avg(tmp)
 delete(tmp)
 dum(n) = gsn_add_polymarker(wks, plot(0), xmarkers, ymarkers, pmres)

 if (n.gt.0) then 
   overlay(plot(0),plot(n))
 end if

 delete(time)
 delete(fpw)
 delete(lhf)
 ;delete(pwstat)
 delete(PW)
 delete(LHF)

 end do

 print("drawing")
 draw(plot(0))
 frame(wks)


;end of ncl script
end 


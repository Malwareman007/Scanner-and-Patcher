load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

fildir="/global/scratch/langhans/"

fnames=(/"Case1_128x128x96_4km_10s_305K_TKE_case1_293760","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_dosgscloudfalse"/);,"Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_mff_ctketau_d20m700"/);,"Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_ctketau_20","Case1_128x128x96_4km_10s_305K_EDMF_case1_293760_doedmffalse_ctketau_350"/)
colors=(/"black","gray","blue","red","darkgreen","maroon4","coral","blue4","orange","coral","blue4","orange","darkgreen","gray","gray","gray","gray","springgreen2","springgreen2","greenyellow","yellow","blue","blue","blue","red","red","red"/)

dashes=(/1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,1,2,3/)

legend = (/"TKE","EDMF 700","EDMF d20m700","EDMF d20m700<2km","EDMF 350","EDMF 50","EDMF 20","TKE","NP tau=700","NP tau=350","NP tau=175","NP tau=80","NP tau=60","NP tau=50","NP tau=20","NP tau=0","TKE sfchomo","TKE sfchomo","TKE sfchomo","TKE sfchomo","TKE sfchomo qv","TKE sfchomo qv","NP 20 after","NP 700 after","NP tau=700 sfchomo qv","NP tau=700 sfchomo qv","NP tau=700 sfchomo qv","NP tau=700 sfchomo qv","NP tau=700 sfchomo qv","NP tau=700 sfchomo qv"/)

plot=new(4*dimsizes(fnames),graphic)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; set time vector for analysis
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
avg_times=0./24.
avg_timee=48./24.

pwcrit=54.

nl=0

do n=0,dimsizes(fnames)-1

file2D=fildir+"/OUT_2D/"+"/"+fnames(n)+"_64.2Dcom_1.nc"

f=addfile(file2D,"r")
time=f->time
time=time-34.

inds= ind(abs(time-avg_times).eq.min(abs(time-avg_times)))
inde= ind(abs(time-avg_timee).eq.min(abs(time-avg_timee)))


nt=0
do t=inds,inde

nt=nt+1

PW2D=f->PW(t,:,:)
CLD=f->CLD(t,:,:)
dims=dimsizes(PW2D)
mask2D=new((/dims(0),dims(1)/),logical)
;mask2D=where(PW2D.gt.pwcrit,True,False)
mask2D=where(CLD.eq.0.0,True,False)

strg=sprinti("%0.10i",floattointeger(round(time(t)*24.*3600./10.,0)))
file3D=fildir+"/OUT_3D/"+fnames(n)+"_64_"+strg+".nc" 
f2=addfile(file3D,"r")
z=f2->z

if (t.eq.inds) then

qvavg=new(dimsizes(z),float)
qrad=new(dimsizes(z),float)
lw=new((/4,dimsizes(z)/),float)
wavg=new(dimsizes(z),float)
qvavg=0.
qrad=0.
lw=0.
wavg=0.

end if

QV3D=f2->QV(0,:,:,:)
W3D=f2->W(0,:,:,:)
QRAD=f2->QRAD(0,:,:,:)
;LWU=f2->LWU(0,:,:,:)
;LWD=f2->LWD(0,:,:,:)
;LWUS=f2->LWUS(0,:,:,:)
;LWDS=f2->LWDS(0,:,:,:)

mask3D=conform(QV3D,mask2D,(/1,2/))
tmp=where(mask3D,QV3D,-999.)
tmp@_FillValue=-999.
qvavg = qvavg + dim_avg_n(tmp,(/1,2/))
tmp=where(mask3D,QRAD,-999.)
qrad = qrad + dim_avg_n(tmp,(/1,2/))
;tmp=where(mask3D,LWU,-999.)
;lw(0,:) = lw(0,:) + dim_avg_n(tmp,(/1,2/))
;tmp=where(mask3D,LWD,-999.)
;lw(1,:) = lw(1,:) + dim_avg_n(tmp,(/1,2/))
;tmp=where(mask3D,LWUS,-999.)
;lw(2,:) = lw(2,:) + dim_avg_n(tmp,(/1,2/))
;tmp=where(mask3D,LWDS,-999.)
;lw(3,:) = lw(3,:) + dim_avg_n(tmp,(/1,2/))
tmp=where(mask3D,W3D,-999.)
wavg = wavg + dim_avg_n(tmp,(/1,2/))


end do

qvavg=qvavg/nt
wavg=wavg/nt
qrad=qrad/nt
lw=lw/nt

zi=new(dimsizes(z),float)
zi(0)=0.
zi(1:dimsizes(z)-1)=0.5*(z(0:dimsizes(z)-2)+z(1:dimsizes(z)-1))


 if (n.eq.0) then
  wks  = gsn_open_wks("eps","w_profile_noncloudy")   ; send graphics to PNG file
  gsn_define_colormap(wks,"MPL_PuBu")

 res                   = True                       ; plot mods desired
 res@gsnFrame = False
 res@gsnDraw  = False
 res@xyMonoDashPattern=True
 res@vpHeightF = 0.5
 res@xyMonoLineColor=True
 res@xyLineColors = (/"red","black","deeppink2","blue","blue"/)
 res@xyLineThicknessF = 2.
 ;res@vpWidthF=0.4
 res@pmLegendWidthF         = 0.12           ; Change width and
 res@pmLegendHeightF        = 0.24
 res@pmLegendSide           = "Top"               ; Change location of
 res@lgJustification = "BottomLeft"
 res@lgPerimOn              =False
 res@lgLabelFontHeightF = 0.02
 res@pmLegendParallelPosF =   0.02
 

 res@tiYAxisString        = "Height (m)"
 res@tiXAxisString        = "q!B!v!N! (m)"
 end if ;(n.eq.0) 

 ;if (n.ge.5.or.n.eq.0) then
 ;if (n.eq.0.or.n.eq.5) then
 ;if (mod(n,3).eq.0) then
 res@pmLegendDisplayMode    = "Always"
 res@pmLegendOrthogonalPosF =  -0.32 -  nl*0.08
 nl=nl+1
 ;else
 ;res@pmLegendDisplayMode    = "Never"
 ;;end if

 res@xyLineColor =  colors(n)
 res@xyDashPattern = dashes(n)
 res@xyExplicitLegendLabels = legend(n)

 res@trXMinF=10.; 0.
 res@trXMaxF=20.
 res@trYMinF=0.; 0.
 res@trYMaxF=2000.

 plot(4*n)  = gsn_csm_xy (wks,qvavg,z,res)


 res@trXMinF=0.2; 0.
 res@trXMaxF=2.
 res@trYMinF=6000.; 0.
 res@trYMaxF=10000.
 plot(4*n+1)  = gsn_csm_xy (wks,qvavg,z,res)


 res@tiXAxisString        = "Q!B!rad!N! (K/day)"
 res@trXMinF=-2.; 0.
 res@trXMaxF=-0.6
 res@trYMinF=0.; 0.
 res@trYMaxF=12000.
 plot(4*n+2)  = gsn_csm_xy (wks,qrad,z,res)

 ;delete(res@xyExplicitLegendLabels)
 ;if (n.eq.0) then
 ;res@pmLegendDisplayMode    = "Always"
 ;else
 ;res@pmLegendDisplayMode    = "Never"
 ;end if
 
 ;res@xyExplicitLegendLabels = (/"all up","all down","clear up","clear down"/)
 ;res@tiXAxisString        = "LW radiative flux (W/m2)"
 res@tiXAxisString        = "Vertical velocity (cm/d)"
 ;res@pmLegendOrthogonalPosF =  -0.12 
 ;res@xyMonoDashPattern=False
 ;res@xyDashPatterns = (/0,1,2,3/)
 ;res@trXMinF=0.; 0.
 ;res@trXMaxF=600.
 res@trXMinF=-20.0; 0.
 res@trXMaxF=0.0
 res@trYMinF=0.; 0.
 res@trYMaxF=12000.
 wavg=wavg/100.*3600.*24.
 plot(4*n+3)  = gsn_csm_xy (wks,wavg,zi,res)
 ;res@xyMonoDashPattern=True
 ;delete(res@xyExplicitLegendLabels)
 ;res@pmLegendDisplayMode    = "Never"

 if (n.gt.0) then
 overlay(plot(0),plot(4*n))
 overlay(plot(1),plot(4*n+1))
 overlay(plot(2),plot(4*n+2))
 overlay(plot(3),plot(4*n+3))
 end if


 delete(time)
 end do ; loop over runs

 gsn_panel(wks,plot(0:3),(/2,2/),False)



;end of ncl script
end 




(* ::Package:: *)
Get["base_runall3.m"]
(* ::Input:: *)
p := 1/10*Boole[-hypothesis<=0]+9/10*Boole[-hypothesis+1<=0] 
np := ((-1/10*eps+1/20)*Boole[-hypothesis<=0]+(9/10*eps+9/20)*Boole[-hypothesis+1<=0])*1/(1/2+4/5*eps)*Boole[-1/2+-eps<=0]*Boole[-1/2+eps<=0]
e := DiracDelta[-r1+9/10]
ne := Boole[-1/2+-eps<=0]*Boole[-1/2+eps<=0]*Boole[-5/8+-eps!=0]*DiracDelta[(9/10*eps+9/20)*1/(1/2+4/5*eps)+-r1]
runall[p,np,e,ne,{{hypothesis,0,1}},(-0.05<=eps<=0.05),(hypothesis==0||hypothesis==1)]
(*pedist[p,q,cons,vars];
pedist[e,ne,-0.02<=eps<=0.02]
pks[p,np,-0.02<=eps<=0.02 && (r1 == 0 || r1 == 1)]
ptvd[p,np,-0.02<=eps<=0.02 && (r1 == 0 || r1 == 1)]
pkl[p,np,-0.02<=eps<=0.02 && (r1 == 0 || r1 == 1)]
*)

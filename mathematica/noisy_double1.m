(* ::Package:: *)
Get["base3.m"]
(* ::Input:: *)
p := 1/2*Boole[-r1+3<=0]+1/2*Boole[-r1+6<=0] 
np :=(-eps+1/2)*Boole[-1/2+-eps<=0]*Boole[-1/2+eps<=0]*Boole[-r1+6<=0]+(1/2+eps)*Boole[-1/2+-eps<=0]*Boole[-1/2+eps<=0]*Boole[-r1+3<=0]
e := DiracDelta[-r1+9/2]
ne := 2*Boole[-6+r1<=0]*Boole[-r1+3<=0]*DiracDelta[-2*r1+-6*eps+9]
pedist[e,ne,-0.05<=eps<=0.05]
pks[p,np,-0.05<=eps<=0.05 && (r1 == 3 || r1 == 6)]
ptvd[p,np,-0.05<=eps<=0.05 && (r1 == 3 || r1 == 6)]
pkl[p,np,-0.05<=eps<=0.05 && (r1 == 3 || r1 == 6)]

(* ::Package:: *)
Get["base3.m"]
(* ::Input:: *)
p := 26/125*Boole[-r1+1<=0]+99/125*Boole[-r1<=0]
np := ((-4/5*eps+99/125)*Boole[-r1<=0]+26/125*Boole[-r1+1<=0]+4/5*Boole[-r1+1<=0]*eps)*Boole[-1/100+-eps<=0]*Boole[-99/100+eps<=0]
e := DiracDelta[-r1+26/125]
ne := 125*Boole[-1+r1<=0]*Boole[-r1+1/5<=0]*DiracDelta[-125*r1+100*eps+26]
pedist[e,ne,-0.001<=eps<=0.001]
pks[p,np,-0.001<=eps<=0.001 && (r1 == 0 || r1 == 1)]
ptvd[p,np,-0.001<=eps<=0.001 && (r1 == 0 || r1 == 1)]
pkl[p,np,-0.001<=eps<=0.001 && (r1 == 0 || r1 == 1)]

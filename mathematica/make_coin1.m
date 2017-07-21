(* ::Package:: *)
Get["base3.m"]
(* ::Input:: *)
makecoinp := 2/5*Boole[-r1+1<=0]+3/5*Boole[-r1<=0]
makecoinnp :=((-eps+1/2)*(1/10*Boole[-r1+1<=0]+9/10*Boole[-r1<=0])+(1/2+eps)*(3/10*Boole[-r1<=0]+7/10*Boole[-r1+1<=0]))*Boole[-1/2+-eps<=0]*Boole[-1/2+eps<=0]
makecoine := DiracDelta[-r1+2/5]
makecoinne :=5*Boole[-7/10+r1<=0]*Boole[-r1+1/10<=0]*DiracDelta[-5*r1+2+3*eps]
pedist[makecoine,makecoinne,-0.05<=eps<=0.05]

pks[makecoinp,makecoinnp,-0.05<=eps<=0.05 && (r1==0||r1==1)]
ptvd[makecoinp,makecoinnp,-0.05<=eps<=0.05 && (r1==0||r1==1)]
pkl[makecoinp,makecoinnp,-0.05<=eps<=0.05 && (r1==0||r1==1)]

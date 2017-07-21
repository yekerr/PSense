(* ::Package:: *)
Get["base3.m"]
(* ::Input:: *)
makecoinp := 2/5*Boole[-r1+1<=0]+3/5*Boole[-r1<=0]
makecoinnp :=((-1/2*eps+3/20)*Boole[-r1<=0]+(1/2*eps+7/20)*Boole[-r1+1<=0])*Boole[-3/10+eps<=0]*Boole[-7/10+-eps<=0]+1/20*Boole[-r1+1<=0]+9/20*Boole[-r1<=0]
makecoine := DiracDelta[-r1+2/5]
makecoinne :=(1/2+1/2*Boole[-3/10+eps<=0]*Boole[-7/10+-eps<=0])*(10*Boole[-11/20+r1<=0]*Boole[-r1+1/20<=0]*DiracDelta[-10*r1+4+5*eps]+Boole[-7/10+-eps!=0]*Boole[7/10+eps<=0]*DiracDelta[-r1+1/10]+Boole[-eps+3/10!=0]*Boole[-eps+3/10<=0]*DiracDelta[-r1+1/10])
Pr_error[] := 1/2*Boole[-7/10+-eps!=0]*Boole[7/10+eps<=0]+1/2*Boole[-eps+3/10!=0]*Boole[-eps+3/10<=0]
pedist[makecoine,makecoinne,-0.07<=eps<=0.07]

pks[makecoinp,makecoinnp,-0.07<=eps<=0.07 && (r1==0||r1==1)]
ptvd[makecoinp,makecoinnp,-0.07<=eps<=0.07 && (r1==0||r1==1)]
pkl[makecoinp,makecoinnp,-0.07<=eps<=0.07 && (r1==0||r1==1)]

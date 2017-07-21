(* ::Package:: *)
Get["base3.m"]
(* ::Input:: *)
makecoinp := 2/5*Boole[-r1+1<=0]+3/5*Boole[-r1<=0]
makecoinnp :=((-1/2*eps+9/20)*Boole[-r1<=0]+(1/2*eps+1/20)*Boole[-r1+1<=0])*Boole[-1/10+-eps<=0]*Boole[-9/10+eps<=0]+3/20*Boole[-r1<=0]+7/20*Boole[-r1+1<=0]
makecoine := DiracDelta[-r1+2/5]
makecoinne :=(1/2+1/2*Boole[-1/10+-eps<=0]*Boole[-9/10+eps<=0])*(10*Boole[-17/20+r1<=0]*Boole[-r1+7/20<=0]*DiracDelta[-10*r1+4+5*eps]+Boole[-1/10+-eps!=0]*Boole[1/10+eps<=0]*DiracDelta[-r1+7/10]+Boole[-eps+9/10!=0]*Boole[-eps+9/10<=0]*DiracDelta[-r1+7/10])
pedist[makecoine,makecoinne,-0.01<=eps<=0.01]
pks[makecoinp,makecoinnp,-0.01<=eps<=0.01 && (r1==0||r1==1)]
ptvd[makecoinp,makecoinnp,-0.01<=eps<=0.01 && (r1==0||r1==1)]
pkl[makecoinp,makecoinnp,-0.01<=eps<=0.01 && (r1==0||r1==1)]

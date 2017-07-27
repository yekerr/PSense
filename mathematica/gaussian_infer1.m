(* ::Package:: *)
Get["base_runall.m"]
(* ::Input:: *)
p := (1/2^(1/2)*Integrate[1/E^(1/2*xi1^2)*Boole[-xi1<=0]*Boole[xi1!=0]*Sqrt[Pi]*(Erf[1/2^(1/2)*1/xi1*r1]+1)/2,{xi1,-Infinity,Infinity}]+1/2^(1/2)*Integrate[1/E^(1/2*xi1^2)*Boole[xi1!=0]*Boole[xi1<=0]*Sqrt[Pi]*(Erf[-1/2^(1/2)*1/xi1*r1]+1)/2,{xi1,-Infinity,Infinity}])*1/Pi
np := ((-eps+4/5)*(1/100*Boole[-r1+1<=0]+99/100*Boole[-r1<=0])+(1/5+eps)*Boole[-r1+1<=0])*Boole[-1/5+-eps<=0]*Boole[-4/5+eps<=0]
e := DiracDelta[-r1+26/125]
ne := 500*Boole[-1+r1<=0]*Boole[-r1+1/100<=0]*DiracDelta[-500*r1+104+495*eps]
runall[p,np,e,ne,{{r1,0,1}},(-0.02<=eps<=0.02),(r1==0||r1==1)]
(*pedist[p,q,cons,vars];
pedist[e,ne,-0.02<=eps<=0.02]
pks[p,np,-0.02<=eps<=0.02 && (r1 == 0 || r1 == 1)]
ptvd[p,np,-0.02<=eps<=0.02 && (r1 == 0 || r1 == 1)]
pkl[p,np,-0.02<=eps<=0.02 && (r1 == 0 || r1 == 1)]
*)

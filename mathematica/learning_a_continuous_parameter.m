(* ::Package:: *)

(* ::Input:: *)
(*p[r1_]:=((-10/3*eps^3+-eps+-eps^5+1/6+1/6*eps^6+5/2*eps^2+5/2*eps^4)*Boole[-eps<=0]+1/6*Boole[eps!=0]*Boole[eps<=0])*((-eps+1)*1/(-10/3*eps^3+-eps+-eps^5+1/6+1/6*eps^6+5/2*eps^2+5/2*eps^4)*Boole[(-10/3*eps^3+-eps+-eps^5+1/6+1/6*eps^6+5/2*eps^2+5/2*eps^4)*1/(-eps+1)!=0]*Boole[-eps<=0]*Boole[eps!=0]+(1/(-1/(-eps+1)*eps+1/(-eps+1)*1/6)*Boole[eps!=0]+6*Boole[eps==0])*Boole[eps<=0]+1/(-1/(-eps+1)*eps+-1/(-eps+1)*eps^3*10/3+-1/(-eps+1)*eps^5+1/(-eps+1)*1/6+1/(-eps+1)*1/6*eps^6+1/(-eps+1)*5/2*eps^2+1/(-eps+1)*5/2*eps^4)*Boole[(-10/3*eps^3+-eps+-eps^5+1/6+1/6*eps^6+5/2*eps^2+5/2*eps^4)*1/(-eps+1)==0]*Boole[-eps<=0]*Boole[eps!=0])*(Boole[(-10/3*eps^3+-eps+-eps^5+1/6+1/6*eps^6+5/2*eps^2+5/2*eps^4)*1/(-eps+1)!=0]*Boole[-eps<=0]*Boole[eps!=0]+Boole[(-10/3*eps^3+-eps+-eps^5+1/6+1/6*eps^6+5/2*eps^2+5/2*eps^4)*1/(-eps+1)==0]*Boole[-1/(-eps+1)*eps*6+-1/(-eps+1)*eps^3*20+-1/(-eps+1)*eps^5*6+1/(-eps+1)+1/(-eps+1)*15*eps^2+1/(-eps+1)*15*eps^4+1/(-eps+1)*eps^6!=0]*Boole[-eps<=0]*Boole[eps!=0]+Boole[-1/(-eps+1)*eps*6+1/(-eps+1)!=0]*Boole[eps<=0])*(Boole[(-10/3*eps^3+-eps+-eps^5+1/6+1/6*eps^6+5/2*eps^2+5/2*eps^4)*1/(-eps+1)!=0]*Boole[-eps<=0]+Boole[eps!=0]*Boole[eps<=0])*(Boole[-eps<=0]*DiracDelta[(-1/7*eps^7+-3*eps^5+-5*eps^3+-eps+1/7+3*eps^2+5*eps^4+eps^6)*1/(-10/3*eps^3+-eps+-eps^5+1/6+1/6*eps^6+5/2*eps^2+5/2*eps^4)+-r1]+Boole[eps!=0]*Boole[eps<=0]*DiracDelta[-r1+6/7])*1/(-eps+1)*Boole[-1+eps<=0]*Boole[-eps+1!=0]*)


(* ::Input:: *)
(*Print[FullSimplify[p[r1],eps>0 && eps < 1]]*)

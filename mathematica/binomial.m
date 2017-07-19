(* ::Package:: *)

(* ::Input:: *)
f[_ DiracDelta[point_]] := Solve[point==0,r1]
f2[DiracDelta[point_]] := Solve[point==0,r1]
distance[p_,q_,cons_] :=FullSimplify[Abs[p-q],cons]
distance2[p_,q_] :=Abs[p-q]
subs[p_, q_,cons_,params_] := FullSimplify[Abs[p-q],cons] /. params 
distancemax[p_,q_,cons_] := FindMaximum[{FullSimplify[Abs[p-q],cons],cons},{eps,r1}]
distancemax2[p_,q_,cons_] := NMaximize[{FullSimplify[Abs[p-q],cons],cons},{eps,r1}]
distancemax3[p_,q_,cons_] := Maximize[{Abs[p-q],cons},{eps,Element[r1,Integers]}]
edistance[p_,q_,cons_]:=distance2[extract[f[p]],extract[f[FullSimplify[q,cons]]]]
edistance2[p_,q_,cons_]:=distance2[extract[f2[p]],extract[f2[FullSimplify[q,cons]]]]
extract[f_] := Values[f][[1]]
edistancemax[p_, q_, cons_] := 
distancemax[extract[f[p]], extract[f[FullSimplify[q,cons]]], cons]
tvd[p_,q_,cons_,min_,max_] :=1/2*Sum[FullSimplify[distance2[p,q],cons],{r1,min,max}]
entropy[p_,q_] := q*Log2[q/p]
kl[p_,q_,cons_,min_,max_]:=Sum[FullSimplify[entropy[p,q],cons],{r1,min,max}]

(* ::Input:: *)
binomialp:=1/625*Boole[-r1+4<=0]+16/625*Boole[-r1+3<=0]+256/625*Boole[-r1+1<=0]+256/625*Boole[-r1<=0]+96/625*Boole[-r1+2<=0]
binomialnp:=((1/10*eps+1/100+1/4*eps^2)*1/(-8/5*eps+16/25+eps^2)*Boole[-r1+2<=0]+(1/10*eps^2+1/50*eps+1/6*eps^3+1/750)*1/(-48/25*eps+-eps^3+12/5*eps^2+64/125)*Boole[-r1+3<=0]+(1/100*eps^2+1/15000+1/24*eps^4+1/30*eps^3+1/750*eps)*1/(-16/5*eps^3+-256/125*eps+256/625+96/25*eps^2+eps^4)*Boole[-r1+4<=0]+(1/30+1/6*eps)*1/(-eps+4/5)*Boole[-r1+1<=0]+1/24*Boole[-r1<=0])*1/((1/10*eps+1/100+1/4*eps^2)*1/(-8/5*eps+16/25+eps^2)+(1/10*eps^2+1/50*eps+1/6*eps^3+1/750)*1/(-48/25*eps+-eps^3+12/5*eps^2+64/125)+(1/100*eps^2+1/15000+1/24*eps^4+1/30*eps^3+1/750*eps)*1/(-16/5*eps^3+-256/125*eps+256/625+96/25*eps^2+eps^4)+(1/30+1/6*eps)*1/(-eps+4/5)+1/24)*Boole[((1/10*eps+1/100+1/4*eps^2)*1/(-8/5*eps+16/25+eps^2)+(1/10*eps^2+1/50*eps+1/6*eps^3+1/750)*1/(-48/25*eps+-eps^3+12/5*eps^2+64/125)+(1/100*eps^2+1/15000+1/24*eps^4+1/30*eps^3+1/750*eps)*1/(-16/5*eps^3+-256/125*eps+256/625+96/25*eps^2+eps^4)+(1/30+1/6*eps)*1/(-eps+4/5)+1/24)*(-384/5*eps^3+-6144/125*eps+2304/25*eps^2+24*eps^4+6144/625)!=0]*Boole[-1/5+-eps<=0]*Boole[-4/5+eps<=0]

binomiale:= DiracDelta[-r1+4/5]
binomialne:=Boole[((1/10*eps+1/100+1/4*eps^2)*1/(-8/5*eps+16/25+eps^2)+(1/10*eps^2+1/50*eps+1/6*eps^3+1/750)*1/(-48/25*eps+-eps^3+12/5*eps^2+64/125)+(1/100*eps^2+1/15000+1/24*eps^4+1/30*eps^3+1/750*eps)*1/(-16/5*eps^3+-256/125*eps+256/625+96/25*eps^2+eps^4)+(1/30+1/6*eps)*1/(-eps+4/5)+1/24)*(-384/5*eps^3+-6144/125*eps+2304/25*eps^2+24*eps^4+6144/625)!=0]*Boole[-1/5+-eps<=0]*Boole[-4/5+eps<=0]*DiracDelta[((-12*eps^4+-128/25*eps^2+1024/3125+4*eps^5+64/5*eps^3)*1/(-eps+4/5)+(-156/5*eps^6+-36/25*eps^4+-576/125*eps^3+1152/3125*eps^2+12*eps^7+3072/78125+612/25*eps^5+6144/15625*eps)*1/(-48/25*eps+-eps^3+12/5*eps^2+64/125)+(-168/5*eps^5+-192/25*eps^3+-384/125*eps^2+12*eps^6+156/5*eps^4+3072/15625+3072/3125*eps)*1/(-8/5*eps+16/25+eps^2)+(-204/125*eps^4+-48/5*eps^7+-576/3125*eps^3+1024/390625+144/125*eps^5+152/25*eps^6+2432/15625*eps^2+3072/78125*eps+4*eps^8)*1/(-16/5*eps^3+-256/125*eps+256/625+96/25*eps^2+eps^4))*1/((1/10*eps+1/100+1/4*eps^2)*1/(-8/5*eps+16/25+eps^2)+(1/10*eps^2+1/50*eps+1/6*eps^3+1/750)*1/(-48/25*eps+-eps^3+12/5*eps^2+64/125)+(1/100*eps^2+1/15000+1/24*eps^4+1/30*eps^3+1/750*eps)*1/(-16/5*eps^3+-256/125*eps+256/625+96/25*eps^2+eps^4)+(1/30+1/6*eps)*1/(-eps+4/5)+1/24)*1/(-384/5*eps^3+-6144/125*eps+2304/25*eps^2+24*eps^4+6144/625)+-r1]


(* ::Input:: *)
Print["edistance"]
Print[edistance[binomiale,binomialne,-0.1<=eps<=0.1]]
Print[""]
Print["distance"]
Print[distance[binomialp,binomialnp,-0.1<=eps<=0.1]]
Print[""]
Print["distancemax"]
d1 := distancemax[binomialp,binomialnp,-0.1<=eps<=0.1 && (r1 == 0 ||r2 == 1 ||r3 == 2 ||r4 == 3)))) ]
Print[d1]
Print[d1[[1]]==subs[binomialp, binomialnp, -0.1<=eps<=0.1 && 0 <= r1 <= 4, d1[[2]]]]
Print["distancemax2"]
d2 := distancemax2[binomialp,binomialnp,-0.1<=eps<=0.1 && 0 <=r1 <= 4]
Print[d2]
Print[d2[[1]]==subs[binomialp, binomialnp, -0.1<=eps<=0.1 && 0 <= r1 <= 4, d2[[2]]]]
Print["distancemax3"]
d3 := distancemax3[binomialp,binomialnp,-0.1<=eps<=0.1 && 0 <=r1 <= 4]
Print[d3[[1]]==subs[binomialp, binomialnp, -0.1<=eps<=0.1 && 0 <= r1 <= 4, d3[[2]]]]
Print[d3]
Print[""]
Print["tvd"]
tvdres := tvd[binomialp,binomialnp,eps>=-0.1 && eps <=0.1,-100,100]
Print[tvdres]
Print[Maximize[{tvdres,-0.1<=eps<=0.1},eps]]
Print[""]
Print["kl"]
klres := kl[binomialp,binomialnp,eps>=-0.1 && eps <=0.1,0,100]
Print[klres]
Print[Maximize[{klres,-0.1<=eps<=0.1},eps]]
Print[""]


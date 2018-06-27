<<SimulationTools`


simDirs = ReplaceList[$ScriptCommandLine,
  {___, "--simulations-directory", val_, ___} :> val];

$SimulationPath = Join[simDirs, $SimulationPath];

outDir = Directory[];


sim="GW150914_32";


MADM=ReadADMMass[sim];


coords1min=ReadAHColumns[sim,1,{15,17,19}];
coords2min=ReadAHColumns[sim,2,{15,17,19}];
coords1max=ReadAHColumns[sim,1,{16,18,20}];
coords2max=ReadAHColumns[sim,2,{16,18,20}];
{coords1mini,coords2mini,coords1maxi,coords2maxi}=Interpolation/@{coords1min,coords2min,coords1max,coords2max};
horizons[t_]:=Show[Graphics3D[{Black,Opacity[1.0],Specularity[0.7],Ellipsoid[(coords1mini[t]+coords1maxi[t])/2,(coords1maxi[t]-coords1mini[t])/2]}],Graphics3D[{Black,Opacity[1.0],Specularity[0.7],Ellipsoid[(coords2mini[t]+coords2maxi[t])/2,(coords2maxi[t]-coords2mini[t])/2]}]]


r0=500;


Do[\[Psi]4[l,m]=ReadPsi4[sim,l,m,r0],{l,2,8},{m,-l,l}];
Do[r\[Psi]4[l,m]=Shifted[r0 \[Psi]4[l,m],-RadialToTortoise[r0,MADM]],{l,2,8},{m,-l,l}];


tMerger=LocateMaximumPoint[Abs[r\[Psi]4[2,2]]];


modes=Sort[Flatten[Table[{l,m,Interpolation[Abs[r\[Psi]4[l,m]],tMerger]},{l,2,8},{m,-l,l}],1],#1[[3]]>#2[[3]]&];


strongestmodes=modes[[1;;8,1;;2]];


\[Omega]0=0.025;


Do[rh[l,m]=Psi4ToStrain[r\[Psi]4[l,m],\[Omega]0],{l,2,8},{m,-l,l}]


Table[rhinterp[l,m]=Interpolation[PadRight[Slab[rh[l,m],MinCoordinate[rh[l,m]];;1050],4000]],{l,2,8},{m,-l,l}];


SpinWeightedSphericalHarmonic[s_,l_,m_,\[Theta]_,\[Phi]_]:=Sqrt[(2 l+1)/(4\[Pi]) ((l+m)!(l-m)!)/((l+s)!(l-s)!)] E^(I m \[Phi]) Sin[\[Theta]/2]^(2 l) \!\(
\*UnderoverscriptBox[\(\[Sum]\), \(r = Max[m - s, 0]\), \(Min[l - s, l + m]\)]\(Binomial[l - s, r]\ Binomial[l + s, r + s - m]\ 
\*SuperscriptBox[\((\(-1\))\), \(l - r - s\)]\ \ 
\*SuperscriptBox[\(Cot[\[Theta]/2]\), \(2\ r + s - m\)]\)\);


rhr\[Theta]\[Phi][r_,\[Theta]_,\[Phi]_]:=With[{t=700},Re[Sum[If[MemberQ[strongestmodes,{l,m}],rhinterp[l,m][t-TortoiseToRadial[r,MADM]]SpinWeightedSphericalHarmonic[-2,l,m,\[Theta],\[Phi]],0],{l,2,8},{m,-l,l}]]];


strainPlot=With[{x0=1.15 0.06,x1=1.15 0.0825,x2=1.2 0.0525,x3=1.2 0.0825},
DensityPlot3D[
Evaluate[With[{r=Sqrt[x^2+y^2+z^2],\[Theta]=ArcCos[z/Sqrt[x^2+y^2+z^2]],\[Phi]=ArcTan[x,y]},rhr\[Theta]\[Phi][r,\[Theta],\[Phi]]]],
{x,-200,200},{y,-200,200},{z,-200,200},ColorFunctionScaling->False,ColorFunction->Function[{f},If[f>0,ColorData[{"DeepSeaColors","Reverse"}][(f-x0)/(x1-x0)],ColorData[{"SolarColors","Reverse"}][(-f-x0)/(x1-x0)]]],OpacityFunctionScaling->False,OpacityFunction-> Function[{f},Max[Min[(Abs[f]-x2)/(x3-x2),1.0],0]],Background->Black,Boxed->False,Axes->False,ViewPoint->Front,ViewAngle->31 Degree,PlotPoints->200,PlotRange->200{{-1,1},{-1,1},{-1,1}}]];


strainHorizonPlot=Show[strainPlot,horizons[745],ViewAngle->28Degree,ImageSize->{400,300}];


Export[FileNameJoin[{outDir,"StrainHorizon.png"}],strainHorizonPlot,ImageSize->{400,300}2160/300]

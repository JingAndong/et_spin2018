<<SimulationTools`


simDirs = ReplaceList[$ScriptCommandLine,
  {___, "--simulations-directory", val_, ___} :> val];

$SimulationPath = Join[simDirs, $SimulationPath];

outDir = Directory[];

sim="GW150914_32";


coords1min=ReadAHColumns[sim,1,{15,17,19}];
coords2min=ReadAHColumns[sim,2,{15,17,19}];
coords1max=ReadAHColumns[sim,1,{16,18,20}];
coords2max=ReadAHColumns[sim,2,{16,18,20}];
{coords1mini,coords2mini,coords1maxi,coords2maxi}=Interpolation/@{coords1min,coords2min,coords1max,coords2max};
horizons[t_]:=Show[Graphics3D[{Black,Opacity[1.0],Specularity[0.7],Ellipsoid[(coords1mini[t]+coords1maxi[t])/2,(coords1maxi[t]-coords1mini[t])/2]}],Graphics3D[{Black,Opacity[1.0],Specularity[0.7],Ellipsoid[(coords2mini[t]+coords2maxi[t])/2,(coords2maxi[t]-coords2mini[t])/2]}]]


(* This function takes a DataRegion on the upper half plane (z\[GreaterEqual]0) and reproduces the data on the full domain assuming the quantity is reflection symmetric about the plane z=0 *)
UpperHalfToFull[d_DataRegion, parity_:1]:=
Module[{dx,dy,dz,xrange,yrange,zrange,fulldata},
{dx,dy,dz}=CoordinateSpacings[d];
{xrange,yrange,zrange}=CoordinateRanges[d];
fulldata=Join[
parity Map[Reverse,ToListOfData[Slab[d,All,All,0;;]],{2}],
ToListOfData[Slab[d,All,All,(0+dz);;]],
3];
ToDataRegion[fulldata,{xrange[[1]],yrange[[1]],-zrange[[2]]},{dx,dy,dz},"VariableName"->VariableName[d]]
];


Re\[Psi]4=ReadGridFunction[sim,"Psi4r","xyz","RefinementLevel"->3,"Map"->0,Iteration->0];


Re\[Psi]4full=UpperHalfToFull[Re\[Psi]4];


its=ReadIterations[sim,"curvIr","xyz",RefinementLevel->3,Map->0];


Re\[ScriptCapitalI]=ReadGridFunction[sim,"curvIr","xyz","RefinementLevel"->3,"Map"->0,"Iteration"->0];
Im\[ScriptCapitalI]=ReadGridFunction[sim,"curvIi","xyz","RefinementLevel"->3,"Map"->0,"Iteration"->0];
Re\[ScriptCapitalJ]=ReadGridFunction[sim,"curvJr","xyz","RefinementLevel"->3,"Map"->0,"Iteration"->0];
Im\[ScriptCapitalJ]=ReadGridFunction[sim,"curvJi","xyz","RefinementLevel"->3,"Map"->0,"Iteration"->0];


Re\[ScriptCapitalI]full=UpperHalfToFull[Re\[ScriptCapitalI]];
Im\[ScriptCapitalI]full=UpperHalfToFull[Im\[ScriptCapitalI],-1];
Re\[ScriptCapitalJ]full=UpperHalfToFull[Re\[ScriptCapitalJ]];
Im\[ScriptCapitalJ]full=UpperHalfToFull[Im\[ScriptCapitalJ],-1];


Psi4Plot=Show[ListContourPlot3D[Re\[Psi]4full,Contours->{-0.01,-0.006,-0.003,-0.001,-0.0005,0.0005,0.001,0.003,0.006,0.01},ContourStyle->Opacity[0.3],Background->Black,Mesh->None,ColorFunction->Function[{x,y,z,f},If[f>0,ColorData[{"DeepSeaColors","Reverse"}][200f],ColorData[{"SolarColors","Reverse"}][-200f]]],ColorFunctionScaling->False,BoxRatios->Automatic],horizons[0],Boxed->False,Axes->False];


Export[FileNameJoin[{outDir,"RePsi4.png"}],Psi4Plot,ImageSize->{Automatic,2160}]


ReIPlot=Show[ListContourPlot3D[Re\[ScriptCapitalI]full,Contours->10^{-1,-2,-3,-4,-5},ContourStyle->Opacity[0.3],Background->Black,Mesh->None,BoxRatios->Automatic,ColorFunction->ColorData[{"DeepSeaColors","Reverse"}]],horizons[0],Boxed->False,Axes->False];


Export[FileNameJoin[{outDir,"ReI.png"}],ReIPlot,ImageSize->{Automatic,2160}]


ImIPlot=Show[ListContourPlot3D[Im\[ScriptCapitalI]full,Contours->Join[-10^{-1,-2,-3,-4,-5,-5.5},10^{-1,-2,-3,-4,-5,-5.5}],ContourStyle->Opacity[0.3],Background->Black,Mesh->None,BoxRatios->Automatic,ColorFunction->Function[{x,y,z,f},If[f>0,ColorData[{"DeepSeaColors","Reverse"}][30000f],ColorData[{"SolarColors","Reverse"}][-30000f]]],ColorFunctionScaling->False],horizons[0],Boxed->False,Axes->False];


Export[FileNameJoin[{outDir,"ImI.png"}],ImIPlot,ImageSize->{Automatic,2160}]

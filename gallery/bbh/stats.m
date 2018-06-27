
<< SimulationTools`;

simDirs = ReplaceList[$ScriptCommandLine,
  {___, "--simulations-directory", val_, ___} :> val];

$SimulationPath = Join[simDirs, $SimulationPath];

outDir = Directory[];

sim = "GW150914_28";

walltimeHours = ReadWalltimeHours[sim];
cores = ReadSimulationCoreCount[sim];
walltimeDays = walltimeHours/24;
cost = cores walltimeHours;
processes = cores/6;
totalMemory = processes*Max[ReadSimulationAverageMemoryUsage[sim]];
finalMass = Last[ReadBlackHoleMass[sim, 3]];
finalSpin = Last[ReadBlackHoleSpin[sim, 3][[3]]] / finalMass^2;
tCAH = MinCoordinate[ReadBlackHoleMass[sim, 3]];

stats =
  {"CostInCoreHours" -> Round[cost],
    "Runtime" -> ToString@NumberForm[walltimeDays,{Infinity,1}],
    "Cores" -> cores,
    "TotalMemory" -> Round[totalMemory/1024],
    "MergerTime" -> Round[tCAH],
    "FinalMass" -> ToString@NumberForm[finalMass,{Infinity,2}],
    "FinalSpin" -> ToString@NumberForm[finalSpin,{Infinity,2}]};

Export["stats.json", stats];

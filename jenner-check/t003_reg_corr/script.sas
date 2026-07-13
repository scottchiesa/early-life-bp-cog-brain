/*
  Extracted from ChiesaBP_Jan2026.sas: the standardize-then-regress modeling
  sequence the manuscript uses to relate cumulative diastolic BP exposure to
  BrainAGE at 45. PROC STANDARD z-scores the analysis variables (mean 0, SD 1),
  the nested PROC REG models add covariates stepwise with standardized betas
  and CIs (stb clb), and PROC CORR reports the exposure/outcome correlations.
  Runs against the mock BP_area from autoexec.sas.
*/
/* restrict to complete cases before standardizing (the upstream step
   does this row filter inline; kept as a DATA step here) */
data BP_complete;
	set BP_area;
	if N(BrainAge45, sex, bmip45, ChildIQ_chstd, NewEduc45, AUC_dia) = 6;
run;

proc standard data = BP_complete out = BP_std m = 0 std = 1;
	var BrainAge45 sex bmip45 ChildIQ_chstd NewEduc45
	    AUC_dia AUC0726_dia AUC2645_dia;
run;

proc reg data = BP_std;
	model BrainAge45 = AUC0726_dia AUC2645_dia / stb clb;
	model BrainAge45 = sex bmip45 AUC0726_dia AUC2645_dia / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 AUC0726_dia AUC2645_dia / stb clb;
	ods output ParameterEstimates = BrainAge_Dia;
run;
quit;

proc corr data = BP_area;
	var AUC_dia AUC0726_dia AUC2645_dia;
	with BrainAge45;
run;

proc print data = BrainAge_Dia; run;

DM   		'LOG; CLEAR; OUT; CLEAR; ';
%LET 		program = C:\Users\rh93\Box Sync\Duke_DPPPlab\Renate2015\2022_Chiesa_BPBrains\ChiesaBP_Jan2022.sas;
FOOTNOTE	"&program on &sysdate.";

*********************************************************************************************;
*  For:          	Chiesa / Dunedin
*  Paper:			High BP & Brain Functioning
*  Programmer:		Renate Houts
*  FILE: 	     	"C:\Users\rh93\Box Sync\Duke_DPPPlab\Renate2015\2022_Chiesa_BPBrains\ChiesaBP_Jan2022.sas"
*
*  Last modified:	28-Jan-2022
*
*********************************************************************************************;

libname BP 		'C:\Users\rh93\Box\Duke_DPPPlab\Renate2015\2022_Chiesa_BPBrains\FromHL';
libname slopes	'C:\Users\rh93\Box\Duke_DPPPlab\Renate2015\2022_Chiesa_BPBrains\slopes';
libname lta		'C:\Users\rh93\Box\Duke_DPPPlab\Renate2015\2022_Chiesa_BPBrains\lta';

proc format;
	value SEX
		1 = 'female'  
		2 = 'male' ;
	value HEALTH
		1 = 'poor'  
		2 = 'fair'  
		3 = 'good'  
		4 = 'very good'  
		5 = 'excellent' ;
	value SYSBP18N
		888 = 'preg' ;
	value SBP38NP
		-9 = 'Missing'  
		-8 = 'Pregnant'  
		-1 = 'Not seen' ;
	value BP_TRAJ
		1 = 'Normal'  
		2 = 'Normal-high'  
		3 = 'Pre-hypertensive'  
		4 = 'Hypertensive' ;
	value SBPGRP
		0 = '<90'  
		1 = '90 to <100'  
		2 = '100 to < 110'  
		3 = '110 to < 120'  
		4 = '120 to < 130'  
		5 = '130 to < 140'  
		6 = '140 thru highest' ;
run;

proc contents data = BP.Chiesa_BP_forRH_march varnum; run;

data BP_preMI1;
	set BP.Chiesa_BP_forRH_march;
	format	sex SEX. Health45 HEALTH. sysbp18np SYSBP18N. sbp38np SBP38NP. 
			BP_traj_UV_975 BP_traj_UV_913 BP_traj_MV_913 BP_TRAJ. 
			sbpgrp18 sbpgrp26 sbpgrp32 sbpgrp38 sbpgrp45 SBPGRP.;

	array sbp [2] sysbp7  sysbp11;
	array sbpg[2] sbpgrp7 spbgrp11;

	do i = 1 to 2;
		if sbp[i] ne . and sbp[i] < 90 then sbpg[i] = 0;
			else if sbp[i] >=  90 and sbp[i] < 100 then sbpg[i] = 1;
			else if sbp[i] >= 100 and sbp[i] < 110 then sbpg[i] = 2;
			else if sbp[i] >= 110 and sbp[i] < 120 then sbpg[i] = 3;
			else if sbp[i] >= 120 and sbp[i] < 130 then sbpg[i] = 4;
			else if sbp[i] >= 130 and sbp[i] < 140 then sbpg[i] = 5;
			else if sbp[i] >= 140 then sbpg[i] = 6;
	end;

	sys7 = sysbp7;  sys11 = sysbp11;  sys18 = sysbp18np; sys26 = sbp26np;  sys32 = sys32np;  sys38 = sbp38np;  sys45 = systbp45C;
	dia7 = diasbp7; dia11 = diasbp11; dia18 = diasbp18;  dia26 = diasbp26; dia32 = diasbp32; dia38 = diasbp38; dia45 = diasbp45C;
	map45 = MeanArtPr45C;
	rx26 = rxHyperTen26; rx32 = rxHyperTen32; rx38 = RxHyperTen38; rx45 = RxHyperTen45;
	BrainAge45 = brainAgeGap45_Liem17_ctrd;
	WMH45      = img_WMHvol_whlBrain_lg45;

	keep snum sex wt00 BrainAge45 Health45 WMH45 img_AveFA45 ArteriolRsd45 Big6craep45 NewEduc45 bmip45 
		 BP_traj_UV_975 BP_traj_UV_913 BP_traj_MV_913 
		 ChildIQ_chstd IQ38_chstd IQ45_chstd IQchng1145 
		 sys7 sys11 sys18 sys26 sys32 sys38 sys45
		 dia7 dia11 dia18 dia26 dia32 dia38 dia45
		 MAP7 MAP11 MAP18 MAP26 MAP32 MAP38 MAP45
		 rx26 rx32  Rx38  Rx45 BPmeds38 BPmeds45;
run;

proc contents data = BP_preMI1 varnum; run;

proc freq data = BP_preMI1;
	table rx26 rx32 Rx38 Rx45 BPmeds38 BPmeds45;
	table Rx38*BPmeds38 Rx45*BPmeds45 / list missing;
run;

proc means data = BP_preMI1;
	class sex;
	var sys7 sys11 sys18 sys26 sys32 sys38 sys45
		dia7 dia11 dia18 dia26 dia32 dia38 dia45
		MAP7 MAP11 MAP18 MAP26 MAP32 MAP38 MAP45
		rx26 rx32  Rx38  Rx45 BPmeds38 BPmeds45;
run;

* Impute data;
data BP_preMI2;
	set BP_preMI1;

	mf_sys7  = 101.7856006; sdf_sys7  =  7.3496793; mf_sys11 = 103.0871518; sdf_sys11 =  7.7593911;
	mf_sys18 = 115.4939904; sdf_sys18 =  9.2544662;	mf_sys26 = 111.5568182; sdf_sys26 =  8.9996093;
	mf_sys32 = 112.5804833; sdf_sys32 = 10.3425933;	mf_sys38 = 116.3695652; sdf_sys38 = 11.2454468;
	mf_sys45 = 116.9560785; sdf_sys45 = 14.1477086;	
	mf_dia7  =  61.071599;  sdf_dia7  =  6.5572798; mf_dia11 =  68.1374663; sdf_dia11 =  7.4325274;
	mf_dia18 =  56.8753086;	sdf_dia18 =  8.8988336; mf_dia26 =  69.8530303; sdf_dia26 =  8.1941523;
	mf_dia32 =  73.8437144; sdf_dia32 =  8.2668375; mf_dia38 =  75.5589371; sdf_dia38 =  9.1022552;
	mf_dia45 =  76.0564831; sdf_dia45 =  9.2016193;	
	mf_map7  =  74.6429329; sdf_map7  =  5.8387323; mf_map11 =  79.7873615; sdf_map11 =  6.5333153;	
	mf_map18 =  76.4592593; sdf_map18 =  7.3185269; mf_map26 =  83.7542929; sdf_map26 =  7.5062885;	
	mf_map32 =  86.7559707; sdf_map32 =  8.1473862; mf_map38 =  89.1434129; sdf_map38 =  9.2707991;	
	mf_map45 =  89.6896816; sdf_map45 = 10.3711255;


	mm_sys7  = 102.7509239; sdm_sys7  =  7.1648522;	mm_sys11 = 102.9835796; sdm_sys11 =  7.0016854;
	mm_sys18 = 125.9064588; sdm_sys18 =  9.4185976;	mm_sys26 = 121.6441718; sdm_sys26 = 10.6803274;
	mm_sys32 = 122.8922952; sdm_sys32 = 10.9253312;	mm_sys38 = 124.0379747; sdm_sys38 = 11.7950337;
	mm_sys45 = 125.5109572; sdm_sys45 = 14.1408797;	
	mm_dia7  =  61.4005913; sdm_dia7  =  6.80756;   mm_dia11 =  67.295977;  sdm_dia11 =  7.3585547;
	mm_dia18 =  57.0614657; sdm_dia18 = 10.5063625; mm_dia26 =  73.3871847; sdm_dia26 = 10.1542547;
	mm_dia32 =  77.7271088; sdm_dia32 =  9.9135809; mm_dia38 =  80.6392405; sdm_dia38 = 10.1453819;
	mm_dia45 =  84.4771051; sdm_dia45 =  9.5213763;
	mm_map7  =  75.1840355; sdm_map7  =  5.972598;  mm_map11 =  79.1918446; sdm_map11 =  6.2750954;	
	mm_map18 =  79.928684;  sdm_map18 =  8.2359058; mm_map26 =  89.4728471; sdm_map26 =  9.1979114;	
	mm_map32 =  92.782171;  sdm_map32 =  9.1860099; mm_map38 =  95.1054852; sdm_map38 = 10.050387;	
	mm_map45 =  98.1550558; sdm_map45 = 10.6871918;

	* BP Variables;
	array sys[7] sys7 sys11 sys18 sys26 sys32 sys38 sys45;
	array dia[7] dia7 dia11 dia18 dia26 dia32 dia38 dia45;
	array map[7] map7 map11 map18 map26 map32 map38 map45;

	* Means;
	array mf_sys[7] mf_sys7 mf_sys11 mf_sys18 mf_sys26 mf_sys32 mf_sys38 mf_sys45;
	array mm_sys[7] mm_sys7 mm_sys11 mm_sys18 mm_sys26 mm_sys32 mm_sys38 mm_sys45;
	array mf_dia[7] mf_dia7 mf_dia11 mf_dia18 mf_dia26 mf_dia32 mf_dia38 mf_dia45;
	array mm_dia[7] mm_dia7 mm_dia11 mm_dia18 mm_dia26 mm_dia32 mm_dia38 mm_dia45;
	array mf_map[7] mf_map7 mf_map11 mf_map18 mf_map26 mf_map32 mf_map38 mf_map45;
	array mm_map[7] mm_map7 mm_map11 mm_map18 mm_map26 mm_map32 mm_map38 mm_map45;

	* SD's;
	array sdf_sys[7] sdf_sys7 sdf_sys11 sdf_sys18 sdf_sys26 sdf_sys32 sdf_sys38 sdf_sys45;
	array sdm_sys[7] sdm_sys7 sdm_sys11 sdm_sys18 sdm_sys26 sdm_sys32 sdm_sys38 sdm_sys45;
	array sdf_dia[7] sdf_dia7 sdf_dia11 sdf_dia18 sdf_dia26 sdf_dia32 sdf_dia38 sdf_dia45;
	array sdm_dia[7] sdm_dia7 sdm_dia11 sdm_dia18 sdm_dia26 sdm_dia32 sdm_dia38 sdm_dia45;
	array sdf_map[7] sdf_map7 sdf_map11 sdf_map18 sdf_map26 sdf_map32 sdf_map38 sdf_map45;
	array sdm_map[7] sdm_map7 sdm_map11 sdm_map18 sdm_map26 sdm_map32 sdm_map38 sdm_map45;

	* Upper Outlier Cut-off;
	array u_sys[7] u_sys7 u_sys11 u_sys18 u_sys26 u_sys32 u_sys38 u_sys45;
	array u_dia[7] u_dia7 u_dia11 u_dia18 u_dia26 u_dia32 u_dia38 u_dia45;
	array u_map[7] u_map7 u_map11 u_map18 u_map26 u_map32 u_map38 u_map45;

	* Lower Outlier Cut-off;
	array l_sys[7] l_sys7 l_sys11 l_sys18 l_sys26 l_sys32 l_sys38 l_sys45;
	array l_dia[7] l_dia7 l_dia11 l_dia18 l_dia26 l_dia32 l_dia38 l_dia45;
	array l_map[7] l_map7 l_map11 l_map18 l_map26 l_map32 l_map38 l_map45;

	* Outlier Indicator;
	array o_sys[7] o_sys7 o_sys11 o_sys18 o_sys26 o_sys32 o_sys38 o_sys45;
	array o_dia[7] o_dia7 o_dia11 o_dia18 o_dia26 o_dia32 o_dia38 o_dia45;
	array o_map[7] o_map7 o_map11 o_map18 o_map26 o_map32 o_map38 o_map45;

	do i = 1 to 7;

		* Determine sex-specific outliers (+/- 2.5 SD);
		o_sys[i] = 0; o_dia[i] = 0; o_map[i] = 0;
		if sex = 1 then do;
			u_sys[i] = mf_sys[i] + sdf_sys[i] * 2.5;
			l_sys[i] = mf_sys[i] - sdf_sys[i] * 2.5;

			u_dia[i] = mf_dia[i] + sdf_dia[i] * 2.5;
			l_dia[i] = mf_dia[i] - sdf_dia[i] * 2.5;

			u_map[i] = mf_map[i] + sdf_map[i] * 2.5;
			l_map[i] = mf_map[i] - sdf_map[i] * 2.5;
		end;
		if sex = 2 then do;
			u_sys[i] = mm_sys[i] + sdm_sys[i] * 2.5;
			l_sys[i] = mm_sys[i] - sdm_sys[i] * 2.5;

			u_dia[i] = mm_dia[i] + sdm_dia[i] * 2.5;
			l_dia[i] = mm_dia[i] - sdm_dia[i] * 2.5;

			u_map[i] = mm_map[i] + sdm_map[i] * 2.5;
			l_map[i] = mm_map[i] - sdm_map[i] * 2.5;
		end;

		* Indicate if SM has uppper or lower outlier;
    	if sys[i] = . then o_sys[i] = .;
			else if sys[i] > u_sys[i] then o_sys[i] =  1;
			else if sys[i] < l_sys[i] then o_sys[i] = -1;
		if dia[i] = . then o_dia[i] = .;
			else if dia[i] > u_dia[i] then o_dia[i] =  1;
			else if dia[i] < l_dia[i] then o_dia[i] = -1;
		if map[i] = . then o_map[i] = .;
			else if map[i] > u_map[i] then o_map[i] =  1;
			else if map[i] < l_map[i] then o_map[i] = -1;
	end;

	* Determine sample size;
	* Missing patterns;

	have_sys7  = N(sys7);
	have_sys11 = N(sys11);
	have_sys18 = N(sys18);
	have_sys26 = N(sys26);
	have_sys32 = N(sys32);
	have_sys38 = N(sys38);
	have_sys45 = N(sys45);
	N_sys745 = SUM(have_sys7, have_sys11, have_sys18, have_sys26, have_sys32, have_sys38, have_sys45);

	have_dia7  = N(dia7);
	have_dia11 = N(dia11);
	have_dia18 = N(dia18);
	have_dia26 = N(dia26);
	have_dia32 = N(dia32);
	have_dia38 = N(dia38);
	have_dia45 = N(dia45);
	N_dia745 = SUM(have_dia7, have_dia11, have_dia18, have_dia26, have_dia32, have_dia38, have_dia45);

	have_map7  = N(map7);
	have_map11 = N(map11);
	have_map18 = N(map18);
	have_map26 = N(map26);
	have_map32 = N(map32);
	have_map38 = N(map38);
	have_map45 = N(map45);
	N_map745 = SUM(have_map7, have_map11, have_map18, have_map26, have_map32, have_map38, have_map45);

	have_brain = N(BrainAge45);

	if N_sys745 < 4 then impute = 0; else if N_sys745 >= 4 then impute = 1;

	drop i
		 mf_sys7 sdf_sys7 mf_sys11 sdf_sys11 mf_sys18 sdf_sys18 mf_sys26 sdf_sys26 mf_sys32 sdf_sys32 mf_sys38 sdf_sys38 mf_sys45 sdf_sys45
		 mf_dia7 sdf_dia7 mf_dia11 sdf_dia11 mf_dia18 sdf_dia18 mf_dia26 sdf_dia26 mf_dia32 sdf_dia32 mf_dia38 sdf_dia38 mf_dia45 sdf_dia45
		 mf_map7 sdf_map7 mf_map11 sdf_map11 mf_map18 sdf_map18 mf_map26 sdf_map26 mf_map32 sdf_map32 mf_map38 sdf_map38 mf_map45 sdf_map45
		 mm_sys7 sdm_sys7 mm_sys11 sdm_sys11 mm_sys18 sdm_sys18 mm_sys26 sdm_sys26 mm_sys32 sdm_sys32 mm_sys38 sdm_sys38 mm_sys45 sdm_sys45 
		 mm_dia7 sdm_dia7 mm_dia11 sdm_dia11 mm_dia18 sdm_dia18 mm_dia26 sdm_dia26 mm_dia32 sdm_dia32 mm_dia38 sdm_dia38 mm_dia45 sdm_dia45 
		 mm_map7 sdm_map7 mm_map11 sdm_map11 mm_map18 sdm_map18 mm_map26 sdm_map26 mm_map32 sdm_map32 mm_map38 sdm_map38 mm_map45 sdm_map45
		 u_sys7  u_sys11  u_sys18  u_sys26   u_sys32  u_sys38   u_sys45  u_map7    u_map11  u_map18   u_map26  u_map32   u_map38  u_map45
		 l_sys7  l_sys11  l_sys18  l_sys26   l_sys32  l_sys38   l_sys45  l_map7    l_map11  l_map18   l_map26  l_map32   l_map38  l_map45; 
run;

data BP_preMI3;
	set BP_preMI2;

	drop o_sys7 o_sys11 o_sys18 o_sys26 o_sys32 o_sys38 o_sys45
		 o_dia7 o_dia11 o_dia18 o_dia26 o_dia32 o_dia38 o_dia45
		 o_map7 o_map11 o_map18 o_map26 o_map32 o_map38 o_map45;
run;

/*
proc freq data = BP_preMI2;
	table have_brain*N_sys745 / list missing;
	table have_sys7*have_sys11*have_sys18*have_sys26*have_sys32*have_sys38*have_sys45 / list missing;
	table have_brain*N_dia745 / list missing;
	table have_dia7*have_dia11*have_dia18*have_dia26*have_dia32*have_dia38*have_dia45 / list missing;
	table have_brain*N_map745 / list missing;
	table have_map7*have_map11*have_map18*have_map26*have_map32*have_map38*have_map45 / list missing;
	table o_sys7 o_sys11 o_sys18 o_sys26 o_sys32 o_sys38 o_sys45;
	table o_dia7 o_dia11 o_dia18 o_dia26 o_dia32 o_dia38 o_dia45;
	table o_map7 o_map11 o_map18 o_map26 o_map32 o_map38 o_map45;
	table impute;
run;

proc univariate data = BP_preMI3 plot;
	var sys7 sys11 sys18 sys26 sys32 sys38 sys45
		dia7 dia11 dia18 dia26 dia32 dia38 dia45
		map7 map11 map18 map26 map32 map38 map45;
run;
proc means data = BP_preMI3;
	class sex;
	var sys7 sys11 sys18 sys26 sys32 sys38 sys45
		dia7 dia11 dia18 dia26 dia32 dia38 dia45
		MAP7 MAP11 MAP18 MAP26 MAP32 MAP38 MAP45
		rx26 rx32  Rx38  Rx45 BPmeds38 BPmeds45;
	where impute = 1;
run;
*/

proc mi data = BP_premi3 seed = 6136980 nimpute = 100 minmaxiter = 1000 out  = BP_miF
		mu0  = 101.9152334 103.1098901 115.5266990 111.6396605 112.5265684 116.2939866 116.8683513 
				61.1908272  68.1300366  56.8992537  69.8734568  73.7796575  75.5007481  76.0561231
		minimum = 0;
		mcmc chain = multiple;
		em maxiter = 500;
		var	sys7 sys11 sys18 sys26 sys32 sys38 sys45
			dia7 dia11 dia18 dia26 dia32 dia38 dia45;
	where impute = 1 and sex = 1;
run;
proc mi data = BP_premi3 seed = 6136980 nimpute = 100 minmaxiter = 1000 out  = BP_miM
		mu0  = 102.7006173 102.9769821 125.9760274 121.5955832 122.8161185 124.0676533 125.4800592 
				61.4336420  67.2766411  57.0641646  73.4168392  77.7179966  80.6490486  84.4549437 
		minimum = 0;
		mcmc chain = multiple;
		em maxiter = 500;
		var	sys7 sys11 sys18 sys26 sys32 sys38 sys45
			dia7 dia11 dia18 dia26 dia32 dia38 dia45;
	where impute = 1 and sex = 2;
run;

proc sort data = BP_miF; by snum; run;
proc sort data = BP_miM; by snum; run;
data BP_imp;
	do i = 1 to 100 until (last.snum);
		set BP_miF BP_miM;
		by snum;
		
		retain	i_sys7 0 i_sys11  0 i_sys18  0 i_sys26  0 i_sys32  0 i_sys38 0 i_sys45
				i_dia7 0 i_dia11  0 i_dia18  0 i_dia26  0 i_dia32  0 i_dia38 0 i_dia45;
				
		if _Imputation_ = 1 then do;
				i_sys7 = 0; i_sys11 = 0; i_sys18 = 0; i_sys26 = 0; i_sys32 = 0; i_sys38 = 0; i_sys45 = 0;
				i_dia7 = 0; i_dia11 = 0; i_dia18 = 0; i_dia26 = 0; i_dia32 = 0; i_dia38 = 0; i_dia45 = 0;
		end;

		array allvar1 [14]	sys7 sys11 sys18 sys26 sys32 sys38 sys45
							dia7 dia11 dia18 dia26 dia32 dia38 dia45;
		array allvar2 [14]	i_sys7 i_sys11 i_sys18 i_sys26 i_sys32 i_sys38 i_sys45
							i_dia7 i_dia11 i_dia18 i_dia26 i_dia32 i_dia38 i_dia45;

		do j = 1 to 14;
			allvar2[j] = allvar2[j] + allvar1[j];
		end;
	end;

	do j = 1 to 14;
		allvar2[j] = allvar2[j] / 100;
	end;
	drop i j _imputation_;

	label	i_sys7   = "Imputed Systolic BP, 7"
			i_sys11  = "Imputed Systolic BP, 11"
			i_sys18  = "Imputed Systolic BP, 18"
			i_sys26  = "Imputed Systolic BP, 26"
			i_sys32  = "Imputed Systolic BP, 32"
			i_sys38  = "Imputed Systolic BP, 38"
			i_sys45  = "Imputed Systolic BP, 45"
			i_dia7   = "Imputed diastolic BP, 7"
			i_dia11  = "Imputed diastolic BP, 11"
			i_dia18  = "Imputed diastolic BP, 18"
			i_dia26  = "Imputed diastolic BP, 26"
			i_dia32  = "Imputed diastolic BP, 32"
			i_dia38  = "Imputed diastolic BP, 38"
			i_dia45  = "Imputed diastolic BP, 45";

	keep snum impute
		 i_sys7 i_sys11 i_sys18 i_sys26 i_sys32 i_sys38 i_sys45
		 i_dia7 i_dia11 i_dia18 i_dia26 i_dia32 i_dia38 i_dia45;
run;

proc sort data = BP_imp; by snum; run;
data BP_imputed;
	merge BP_preMI1 BP_imp;
	by snum;

	array s[7] i_sys7 i_sys11 i_sys18 i_sys26 i_sys32 i_sys38 i_sys45;
	array d[7] i_dia7 i_dia11 i_dia18 i_dia26 i_dia32 i_dia38 i_dia45;
	array m[7] i_MAP7 i_MAP11 i_MAP18 i_MAP26 i_MAP32 i_MAP38 i_MAP45;

	do i = 1 to 7;
		m[i] = (s[i] + 2*d[i])/3;
	end;
	
	label	i_map7   = "Imputed Mean Arterial Pressure, 7"
			i_map11  = "Imputed Mean Arterial Pressure, 11"
			i_map18  = "Imputed Mean Arterial Pressure, 18"
			i_map26  = "Imputed Mean Arterial Pressure, 26"
			i_map32  = "Imputed Mean Arterial Pressure, 32"
			i_map38  = "Imputed Mean Arterial Pressure, 38"
			i_map45  = "Imputed Mean Arterial Pressure, 45";
run;
proc means data = BP_imputed;
	var i_sys7 i_sys11 i_sys18 i_sys26 i_sys32 i_sys38 i_sys45
		i_dia7 i_dia11 i_dia18 i_dia26 i_dia32 i_dia38 i_dia45
		i_MAP7 i_MAP11 i_MAP18 i_MAP26 i_MAP32 i_MAP38 i_MAP45;
run;

data BP_area;
	set BP_imputed;

	sys_A711  = 0.5*((i_sys7  - 80) + (i_sys11 - 80))*(11- 7);
	sys_A1118 = 0.5*((i_sys11 - 80) + (i_sys18 - 80))*(18-11);
	sys_A1826 = 0.5*((i_sys18 - 80) + (i_sys26 - 80))*(26-18);
	sys_A2632 = 0.5*((i_sys26 - 80) + (i_sys32 - 80))*(32-26);
	sys_A3238 = 0.5*((i_sys32 - 80) + (i_sys38 - 80))*(38-32);
	sys_A3845 = 0.5*((i_sys38 - 80) + (i_sys45 - 80))*(45-38);

	AUC_sys   = SUM(sys_A711, sys_A1118, sys_A1826, sys_A2632, sys_A3238, sys_A3845);
	avg_sys   = MEAN(i_sys7, i_sys11, i_sys18, i_sys26, i_sys32, i_sys38, i_sys45);
	std_sys   = STD(i_sys7, i_sys11, i_sys18, i_sys26, i_sys32, i_sys38, i_sys45);
	max_sys   = MAX(i_sys7, i_sys11, i_sys18, i_sys26, i_sys32, i_sys38, i_sys45);
	min_sys   = MIN(i_sys7, i_sys11, i_sys18, i_sys26, i_sys32, i_sys38, i_sys45);
	dif_sys   = max_sys - min_sys;

	AUC0711_sys = sys_A711;
	AUC1126_sys = SUM(sys_A1118, sys_A1826);
	AUC2645_sys = SUM(sys_A2632, sys_A3238, sys_A3845); 
	AUC0726_sys = SUM(sys_A711, sys_A1118, sys_A1826);

	dia_A711  = 0.5*((i_dia7  - 30) + (i_dia11 - 30))*(11- 7);
	dia_A1118 = 0.5*((i_dia11 - 30) + (i_dia18 - 30))*(18-11);
	dia_A1826 = 0.5*((i_dia18 - 30) + (i_dia26 - 30))*(26-18);
	dia_A2632 = 0.5*((i_dia26 - 30) + (i_dia32 - 30))*(32-26);
	dia_A3238 = 0.5*((i_dia32 - 30) + (i_dia38 - 30))*(38-32);
	dia_A3845 = 0.5*((i_dia38 - 30) + (i_dia45 - 30))*(45-38);

	AUC_dia   = SUM(dia_A711, dia_A1118, dia_A1826, dia_A2632, dia_A3238, dia_A3845);
	avg_dia   = MEAN(i_dia7, i_dia11, i_dia18, i_dia26, i_dia32, i_dia38, i_dia45);
	std_dia   = STD(i_dia7, i_dia11, i_dia18, i_dia26, i_dia32, i_dia38, i_dia45);
	max_dia   = MAX(i_dia7, i_dia11, i_dia18, i_dia26, i_dia32, i_dia38, i_dia45);
	min_dia   = MIN(i_dia7, i_dia11, i_dia18, i_dia26, i_dia32, i_dia38, i_dia45);
	dif_dia   = max_dia - min_dia;

	AUC0711_dia = dia_A711;
	AUC1126_dia = SUM(dia_A1118, dia_A1826);
	AUC2645_dia = SUM(dia_A2632, dia_A3238, dia_A3845); 
	AUC0726_dia = SUM(dia_A711, dia_A1118, dia_A1826);

	map_A711  = 0.5*((i_map7  - 50) + (i_map11 - 50))*(11- 7);
	map_A1118 = 0.5*((i_map11 - 50) + (i_map18 - 50))*(18-11);
	map_A1826 = 0.5*((i_map18 - 50) + (i_map26 - 50))*(26-18);
	map_A2632 = 0.5*((i_map26 - 50) + (i_map32 - 50))*(32-26);
	map_A3238 = 0.5*((i_map32 - 50) + (i_map38 - 50))*(38-32);
	map_A3845 = 0.5*((i_map38 - 50) + (i_map45 - 50))*(45-38);

	AUC_map   = SUM(map_A711, map_A1118, map_A1826, map_A2632, map_A3238, map_A3845);
	avg_map   = MEAN(i_map7, i_map11, i_map18, i_map26, i_map32, i_map38, i_map45);
	std_map   = STD(i_map7, i_map11, i_map18, i_map26, i_map32, i_map38, i_map45);
	max_map   = MAX(i_map7, i_map11, i_map18, i_map26, i_map32, i_map38, i_map45);
	min_map   = MIN(i_map7, i_map11, i_map18, i_map26, i_map32, i_map38, i_map45);
	dif_map   = max_map - min_map;

	AUC0711_map = map_A711;
	AUC1126_map = SUM(map_A1118, map_A1826);
	AUC2645_map = SUM(map_A2632, map_A3238, map_A3845); 
	AUC0726_map = SUM(map_A711, map_A1118, map_A1826);
run;

proc standard data = BP_area out = BP_std m = 0 std = 1;
	var BrainAge45 sex bmip45 ChildIQ_chstd NewEduc45
		i_dia7 i_dia11 i_dia18 i_dia26 i_dia32 i_dia38 i_dia45 AUC_dia AUC0711_dia AUC1126_dia AUC2645_dia AUC0726_dia;
	where N(BrainAge45, sex, bmip45, ChildIQ_chstd, NewEduc45, AUC_dia) = 6;
run;
proc reg data = BP_std;
	/*model BrainAge45 = i_dia7             / stb clb;
	model BrainAge45 = sex bmip45 i_dia7  / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia7  / stb clb;
	model BrainAge45 = i_dia11 / stb clb;
	model BrainAge45 = sex bmip45 i_dia11 / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia11 / stb clb;
	model BrainAge45 = i_dia18 / stb clb;
	model BrainAge45 = sex bmip45 i_dia18 / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia18 / stb clb;
	model BrainAge45 = i_dia26 / stb clb;
	model BrainAge45 = sex bmip45 i_dia26 / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia26 / stb clb;
	model BrainAge45 = i_dia32 / stb clb;
	model BrainAge45 = sex bmip45 i_dia32 / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia32 / stb clb;
	model BrainAge45 = i_dia38 / stb clb;
	model BrainAge45 = sex bmip45 i_dia38 / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia38 / stb clb;
	model BrainAge45 = i_dia45 / stb clb;
	model BrainAge45 = sex bmip45 i_dia45 / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia45 / stb clb;
	model BrainAge45 = AUC_dia / stb clb;
	model BrainAge45 = sex bmip45 AUC_dia / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 AUC_dia / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia45 AUC_dia / stb clb;
	model BrainAge45 = AUC0711_dia AUC1126_dia AUC2645_dia / stb clb;
	model BrainAge45 = sex bmip45 AUC0711_dia AUC1126_dia AUC2645_dia / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 AUC0711_dia AUC1126_dia AUC2645_dia / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia45 AUC0711_dia AUC1126_dia AUC2645_dia / stb clb; */
	model BrainAge45 = AUC0726_dia AUC2645_dia / stb clb;
	model BrainAge45 = sex bmip45 AUC0726_dia AUC2645_dia / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 AUC0726_dia AUC2645_dia / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia45 AUC0726_dia AUC2645_dia / stb clb;
	ods output ParameterEstimates = BrainAge_Dia;
run;
quit;

proc standard data = BP_area out = BP_std m = 0 std = 1;
	var BrainAge45 sex bmip45 ChildIQ_chstd NewEduc45
		i_sys7 i_sys11 i_sys18 i_sys26 i_sys32 i_sys38 i_sys45 AUC_sys AUC0711_sys AUC1126_sys AUC2645_sys AUC0726_sys;
	where N(BrainAge45, sex, bmip45, ChildIQ_chstd, NewEduc45, AUC_sys) = 6;
run;
proc reg data = BP_std;
	/*model BrainAge45 = i_sys7             / stb clb;
	model BrainAge45 = sex bmip45 i_sys7  / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys7  / stb clb;
	model BrainAge45 = i_sys11 / stb clb;
	model BrainAge45 = sex bmip45 i_sys11 / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys11 / stb clb;
	model BrainAge45 = i_sys18 / stb clb;
	model BrainAge45 = sex bmip45 i_sys18 / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys18 / stb clb;
	model BrainAge45 = i_sys26 / stb clb;
	model BrainAge45 = sex bmip45 i_sys26 / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys26 / stb clb;
	model BrainAge45 = i_sys32 / stb clb;
	model BrainAge45 = sex bmip45 i_sys32 / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys32 / stb clb;
	model BrainAge45 = i_sys38 / stb clb;
	model BrainAge45 = sex bmip45 i_sys38 / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys38 / stb clb;
	model BrainAge45 = i_sys45 / stb clb;
	model BrainAge45 = sex bmip45 i_sys45 / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys45 / stb clb;
	model BrainAge45 = AUC_sys / stb clb;
	model BrainAge45 = sex bmip45 AUC_sys / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 AUC_sys / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys45 AUC_sys / stb clb;
	model BrainAge45 = AUC0711_sys AUC1126_sys AUC2645_sys / stb clb;
	model BrainAge45 = sex bmip45 AUC0711_sys AUC1126_sys AUC2645_sys / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 AUC0711_sys AUC1126_sys AUC2645_sys / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys45 AUC0711_sys AUC1126_sys AUC2645_sys / stb clb; */
	*model BrainAge45 = AUC0726_sys AUC2645_sys / stb clb;
	*model BrainAge45 = sex bmip45 AUC0726_sys AUC2645_sys / stb clb;
	model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 AUC0726_sys AUC2645_sys / stb clb;
	*model BrainAge45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys45 AUC0726_sys AUC2645_sys / stb clb;
	*ods output ParameterEstimates = BrainAge_sys;
run;
quit;


proc standard data = BP_area out = BP_std m = 0 std = 1;
	var WMH45 sex bmip45 ChildIQ_chstd NewEduc45
		i_dia7 i_dia11 i_dia18 i_dia26 i_dia32 i_dia38 i_dia45 AUC_dia AUC0711_dia AUC1126_dia AUC2645_dia AUC0726_dia;
	where N(WMH45, sex, bmip45, ChildIQ_chstd, NewEduc45, AUC_dia) = 6;
run;
proc reg data = BP_std;
	/*model WMH45 = i_dia7             / stb clb;
	model WMH45 = sex bmip45 i_dia7  / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia7  / stb clb;
	model WMH45 = i_dia11 / stb clb;
	model WMH45 = sex bmip45 i_dia11 / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia11 / stb clb;
	model WMH45 = i_dia18 / stb clb;
	model WMH45 = sex bmip45 i_dia18 / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia18 / stb clb;
	model WMH45 = i_dia26 / stb clb;
	model WMH45 = sex bmip45 i_dia26 / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia26 / stb clb;
	model WMH45 = i_dia32 / stb clb;
	model WMH45 = sex bmip45 i_dia32 / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia32 / stb clb;
	model WMH45 = i_dia38 / stb clb;
	model WMH45 = sex bmip45 i_dia38 / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia38 / stb clb;
	model WMH45 = i_dia45 / stb clb;
	model WMH45 = sex bmip45 i_dia45 / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia45 / stb clb;
	model WMH45 = AUC_dia / stb clb;
	model WMH45 = sex bmip45 AUC_dia / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 AUC_dia / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia45 AUC_dia / stb clb;
	model WMH45 = AUC0711_dia AUC1126_dia AUC2645_dia / stb clb;
	model WMH45 = sex bmip45 AUC0711_dia AUC1126_dia AUC2645_dia / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 AUC0711_dia AUC1126_dia AUC2645_dia / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia45 AUC0711_dia AUC1126_dia AUC2645_dia / stb clb; */
	model WMH45 = AUC0726_dia AUC2645_dia / stb clb;
	model WMH45 = sex bmip45 AUC0726_dia AUC2645_dia / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 AUC0726_dia AUC2645_dia / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia45 AUC0726_dia AUC2645_dia / stb clb;
	ods output ParameterEstimates = WMH_Dia;
run;
quit;

proc standard data = BP_area out = BP_std m = 0 std = 1;
	var WMH45 sex bmip45 ChildIQ_chstd NewEduc45
		i_sys7 i_sys11 i_sys18 i_sys26 i_sys32 i_sys38 i_sys45 AUC_sys AUC0711_sys AUC1126_sys AUC2645_sys AUC0726_sys;
	where N(WMH45, sex, bmip45, ChildIQ_chstd, NewEduc45, AUC_sys) = 6;
run;
proc reg data = BP_std;
	/*model WMH45 = i_sys7             / stb clb;
	model WMH45 = sex bmip45 i_sys7  / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys7  / stb clb;
	model WMH45 = i_sys11 / stb clb;
	model WMH45 = sex bmip45 i_sys11 / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys11 / stb clb;
	model WMH45 = i_sys18 / stb clb;
	model WMH45 = sex bmip45 i_sys18 / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys18 / stb clb;
	model WMH45 = i_sys26 / stb clb;
	model WMH45 = sex bmip45 i_sys26 / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys26 / stb clb;
	model WMH45 = i_sys32 / stb clb;
	model WMH45 = sex bmip45 i_sys32 / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys32 / stb clb;
	model WMH45 = i_sys38 / stb clb;
	model WMH45 = sex bmip45 i_sys38 / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys38 / stb clb;
	model WMH45 = i_sys45 / stb clb;
	model WMH45 = sex bmip45 i_sys45 / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys45 / stb clb;
	model WMH45 = AUC_sys / stb clb;
	model WMH45 = sex bmip45 AUC_sys / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 AUC_sys / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys45 AUC_sys / stb clb;
	model WMH45 = AUC0711_sys AUC1126_sys AUC2645_sys / stb clb;
	model WMH45 = sex bmip45 AUC0711_sys AUC1126_sys AUC2645_sys / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 AUC0711_sys AUC1126_sys AUC2645_sys / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys45 AUC0711_sys AUC1126_sys AUC2645_sys / stb clb;*/
	model WMH45 = AUC0726_sys AUC2645_sys / stb clb;
	model WMH45 = sex bmip45 AUC0726_sys AUC2645_sys / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 AUC0726_sys AUC2645_sys / stb clb;
	model WMH45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys45 AUC0726_sys AUC2645_sys / stb clb;
	ods output ParameterEstimates = WMH_sys;
run;
quit;

proc standard data = BP_area out = BP_std m = 0 std = 1;
	var IQ45_chstd sex bmip45 ChildIQ_chstd NewEduc45
		i_dia7 i_dia11 i_dia18 i_dia26 i_dia32 i_dia38 i_dia45 AUC_dia AUC0711_dia AUC1126_dia AUC2645_dia AUC0726_dia;
	where N(IQ45_chstd, sex, bmip45, ChildIQ_chstd, NewEduc45, AUC_dia) = 6;
run;
proc reg data = BP_std;
	/*model IQ45_chstd = i_dia7             / stb clb;
	model IQ45_chstd = sex bmip45 i_dia7  / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 i_dia7  / stb clb;
	model IQ45_chstd = i_dia11 / stb clb;
	model IQ45_chstd = sex bmip45 i_dia11 / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 i_dia11 / stb clb;
	model IQ45_chstd = i_dia18 / stb clb;
	model IQ45_chstd = sex bmip45 i_dia18 / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 i_dia18 / stb clb;
	model IQ45_chstd = i_dia26 / stb clb;
	model IQ45_chstd = sex bmip45 i_dia26 / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 i_dia26 / stb clb;
	model IQ45_chstd = i_dia32 / stb clb;
	model IQ45_chstd = sex bmip45 i_dia32 / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 i_dia32 / stb clb;
	model IQ45_chstd = i_dia38 / stb clb;
	model IQ45_chstd = sex bmip45 i_dia38 / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 i_dia38 / stb clb;
	model IQ45_chstd = i_dia45 / stb clb;
	model IQ45_chstd = sex bmip45 i_dia45 / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 i_dia45 / stb clb;
	model IQ45_chstd = AUC_dia / stb clb;
	model IQ45_chstd = sex bmip45 AUC_dia / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 AUC_dia / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 i_dia45 AUC_dia / stb clb;
	model IQ45_chstd = AUC0711_dia AUC1126_dia AUC2645_dia / stb clb;
	model IQ45_chstd = sex bmip45 AUC0711_dia AUC1126_dia AUC2645_dia / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 AUC0711_dia AUC1126_dia AUC2645_dia / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 i_dia45 AUC0711_dia AUC1126_dia AUC2645_dia / stb clb; */
	model IQ45_chstd = AUC0726_dia AUC2645_dia / stb clb;
	model IQ45_chstd = sex bmip45 AUC0726_dia AUC2645_dia / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 AUC0726_dia AUC2645_dia / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 i_dia45 AUC0726_dia AUC2645_dia / stb clb;
	ods output ParameterEstimates = IQ_Dia;
run;
quit;

proc standard data = BP_area out = BP_std m = 0 std = 1;
	var IQ45_chstd sex bmip45 ChildIQ_chstd NewEduc45
		i_sys7 i_sys11 i_sys18 i_sys26 i_sys32 i_sys38 i_sys45 AUC_sys AUC0711_sys AUC1126_sys AUC2645_sys AUC0726_sys;
	where N(IQ45_chstd, sex, bmip45, ChildIQ_chstd, NewEduc45, AUC_sys) = 6;
run;
proc reg data = BP_std;
	/*model IQ45_chstd = i_sys7             / stb clb;
	model IQ45_chstd = sex bmip45 i_sys7  / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 i_sys7  / stb clb;
	model IQ45_chstd = i_sys11 / stb clb;
	model IQ45_chstd = sex bmip45 i_sys11 / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 i_sys11 / stb clb;
	model IQ45_chstd = i_sys18 / stb clb;
	model IQ45_chstd = sex bmip45 i_sys18 / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 i_sys18 / stb clb;
	model IQ45_chstd = i_sys26 / stb clb;
	model IQ45_chstd = sex bmip45 i_sys26 / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 i_sys26 / stb clb;
	model IQ45_chstd = i_sys32 / stb clb;
	model IQ45_chstd = sex bmip45 i_sys32 / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 i_sys32 / stb clb;
	model IQ45_chstd = i_sys38 / stb clb;
	model IQ45_chstd = sex bmip45 i_sys38 / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 i_sys38 / stb clb;
	model IQ45_chstd = i_sys45 / stb clb;
	model IQ45_chstd = sex bmip45 i_sys45 / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 i_sys45 / stb clb;
	model IQ45_chstd = AUC_sys / stb clb;
	model IQ45_chstd = sex bmip45 AUC_sys / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 AUC_sys / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 i_sys45 AUC_sys / stb clb;
	model IQ45_chstd = AUC0711_sys AUC1126_sys AUC2645_sys / stb clb;
	model IQ45_chstd = sex bmip45 AUC0711_sys AUC1126_sys AUC2645_sys / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 AUC0711_sys AUC1126_sys AUC2645_sys / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 i_sys45 AUC0711_sys AUC1126_sys AUC2645_sys / stb clb; */
	model IQ45_chstd = AUC0726_sys AUC2645_sys / stb clb;
	model IQ45_chstd = sex bmip45 AUC0726_sys AUC2645_sys / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 AUC0726_sys AUC2645_sys / stb clb;
	model IQ45_chstd = sex bmip45 ChildIQ_chstd NewEduc45 i_sys45 AUC0726_sys AUC2645_sys / stb clb;
	ods output ParameterEstimates = IQ_sys;
run;
quit;


proc standard data = BP_area out = BP_std m = 0 std = 1;
	var ArteriolRsd45 sex bmip45 ChildIQ_chstd NewEduc45
		i_dia7 i_dia11 i_dia18 i_dia26 i_dia32 i_dia38 i_dia45 AUC_dia AUC0711_dia AUC1126_dia AUC2645_dia AUC0726_dia;
	where N(ArteriolRsd45, sex, bmip45, ChildIQ_chstd, NewEduc45, AUC_dia) = 6;
run;
proc reg data = BP_std;
	/*model ArteriolRsd45 = i_dia7             / stb clb;
	model ArteriolRsd45 = sex bmip45 i_dia7  / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia7  / stb clb;
	model ArteriolRsd45 = i_dia11 / stb clb;
	model ArteriolRsd45 = sex bmip45 i_dia11 / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia11 / stb clb;
	model ArteriolRsd45 = i_dia18 / stb clb;
	model ArteriolRsd45 = sex bmip45 i_dia18 / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia18 / stb clb;
	model ArteriolRsd45 = i_dia26 / stb clb;
	model ArteriolRsd45 = sex bmip45 i_dia26 / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia26 / stb clb;
	model ArteriolRsd45 = i_dia32 / stb clb;
	model ArteriolRsd45 = sex bmip45 i_dia32 / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia32 / stb clb;
	model ArteriolRsd45 = i_dia38 / stb clb;
	model ArteriolRsd45 = sex bmip45 i_dia38 / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia38 / stb clb;
	model ArteriolRsd45 = i_dia45 / stb clb;
	model ArteriolRsd45 = sex bmip45 i_dia45 / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia45 / stb clb;
	model ArteriolRsd45 = AUC_dia / stb clb;
	model ArteriolRsd45 = sex bmip45 AUC_dia / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 AUC_dia / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia45 AUC_dia / stb clb;
	model ArteriolRsd45 = AUC0711_dia AUC1126_dia AUC2645_dia / stb clb;
	model ArteriolRsd45 = sex bmip45 AUC0711_dia AUC1126_dia AUC2645_dia / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 AUC0711_dia AUC1126_dia AUC2645_dia / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia45 AUC0711_dia AUC1126_dia AUC2645_dia / stb clb; */
	model ArteriolRsd45 = AUC0726_dia AUC2645_dia / stb clb;
	model ArteriolRsd45 = sex bmip45 AUC0726_dia AUC2645_dia / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 AUC0726_dia AUC2645_dia / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 i_dia45 AUC0726_dia AUC2645_dia / stb clb;
	ods output ParameterEstimates = Arteriole_Dia;
run;
quit;

proc standard data = BP_area out = BP_std m = 0 std = 1;
	var ArteriolRsd45 sex bmip45 ChildIQ_chstd NewEduc45
		i_sys7 i_sys11 i_sys18 i_sys26 i_sys32 i_sys38 i_sys45 AUC_sys AUC0711_sys AUC1126_sys AUC2645_sys AUC0726_sys;
	where N(ArteriolRsd45, sex, bmip45, ChildIQ_chstd, NewEduc45, AUC_sys) = 6;
run;
proc reg data = BP_std;
	/*model ArteriolRsd45 = i_sys7             / stb clb;
	model ArteriolRsd45 = sex bmip45 i_sys7  / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys7  / stb clb;
	model ArteriolRsd45 = i_sys11 / stb clb;
	model ArteriolRsd45 = sex bmip45 i_sys11 / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys11 / stb clb;
	model ArteriolRsd45 = i_sys18 / stb clb;
	model ArteriolRsd45 = sex bmip45 i_sys18 / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys18 / stb clb;
	model ArteriolRsd45 = i_sys26 / stb clb;
	model ArteriolRsd45 = sex bmip45 i_sys26 / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys26 / stb clb;
	model ArteriolRsd45 = i_sys32 / stb clb;
	model ArteriolRsd45 = sex bmip45 i_sys32 / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys32 / stb clb;
	model ArteriolRsd45 = i_sys38 / stb clb;
	model ArteriolRsd45 = sex bmip45 i_sys38 / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys38 / stb clb;
	model ArteriolRsd45 = i_sys45 / stb clb;
	model ArteriolRsd45 = sex bmip45 i_sys45 / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys45 / stb clb;
	model ArteriolRsd45 = AUC_sys / stb clb;
	model ArteriolRsd45 = sex bmip45 AUC_sys / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 AUC_sys / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys45 AUC_sys / stb clb;
	model ArteriolRsd45 = AUC0711_sys AUC1126_sys AUC2645_sys / stb clb;
	model ArteriolRsd45 = sex bmip45 AUC0711_sys AUC1126_sys AUC2645_sys / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 AUC0711_sys AUC1126_sys AUC2645_sys / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys45 AUC0711_sys AUC1126_sys AUC2645_sys / stb clb; */
	model ArteriolRsd45 = AUC0726_sys AUC2645_sys / stb clb;
	model ArteriolRsd45 = sex bmip45 AUC0726_sys AUC2645_sys / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 AUC0726_sys AUC2645_sys / stb clb;
	model ArteriolRsd45 = sex bmip45 ChildIQ_chstd NewEduc45 i_sys45 AUC0726_sys AUC2645_sys / stb clb;
	ods output ParameterEstimates = Arteriole_sys;
run;
quit;

proc corr data = BP_area;
	var i_dia7 i_dia11 i_dia18 i_dia26 i_dia32 i_dia38 i_dia45 AUC_dia AUC0711_dia AUC1126_dia AUC0726_dia AUC2645_dia
		i_sys7 i_sys11 i_sys18 i_sys26 i_sys32 i_sys38 i_sys45 AUC_sys AUC0711_sys AUC1126_sys AUC0726_sys AUC2645_sys;
run;
proc corr data = BP_area;
	var i_dia7 i_dia11 i_dia18 i_dia26 i_dia32 i_dia38 i_dia45 AUC_dia AUC0711_dia AUC1126_dia AUC0726_dia AUC2645_dia
		i_sys7 i_sys11 i_sys18 i_sys26 i_sys32 i_sys38 i_sys45 AUC_sys AUC0711_sys AUC1126_sys AUC0726_sys AUC2645_sys;
	with
		BrainAge45 WMH45 ArteriolRsd45 IQ45_chstd;
run;


proc print data = BrainAge_dia; run;
proc print data = BrainAge_sys; run;

proc print data = WMH_dia; run;
proc print data = WMH_sys; run;

proc print data = IQ_dia; run;

data IQ_sys1;
	set IQ_sys;

	where variable in ("i_sys7", "i_sys11", "i_sys18", "i_sys26", "i_sys32", "i_sys38", "i_sys45", "AUC_sys");
run;
proc print data = IQ_sys; run;

data Arteriole_dia1;
	set Arteriole_dia;

	where variable in ("i_dia7", "i_dia11", "i_dia18", "i_dia26", "i_dia32", "i_dia38", "i_dia45", "AUC_dia");
run;
proc print data = Arteriole_dia; run;

data Arteriole_sys1;
	set Arteriole_sys;

	where variable in ("i_sys7", "i_sys11", "i_sys18", "i_sys26", "i_sys32", "i_sys38", "i_sys45", "AUC_sys");
run;
proc print data = Arteriole_sys; run;


proc standard data = BP_area out = BP_toR (rename = (IQ45_chstd = IQ45)) m = 100 std = 15;
	var IQ45_chstd;
run;

data toR;
	set BP_toR;

	format 	snum sex
			i_dia7 i_dia11 i_dia18 i_dia26 i_dia32 i_dia38 i_dia45 AUC_dia
			i_sys7 i_sys11 i_sys18 i_sys26 i_sys32 i_sys38 i_sys45 AUC_sys
			IQ45 WMH45 BrainAge45 ArteriolRsd45;

	keep 	snum sex
			i_dia7 i_dia11 i_dia18 i_dia26 i_dia32 i_dia38 i_dia45 AUC_dia
			i_sys7 i_sys11 i_sys18 i_sys26 i_sys32 i_sys38 i_sys45 AUC_sys
			IQ45 WMH45 BrainAge45 ArteriolRsd45;
run;

proc export data = toR outfile = "C:\Users\rh93\Box\Duke_DPPPlab\Renate2015\2022_Chiesa_BPBrains\toR_Feb2024.csv"
	dbms = csv replace;
run;
quit;

proc means data = BP_toR;
	var ArteriolRsd45;
run;

* Descriptive statistics;
proc freq data = BP_area;
	table sex NewEduc45;
	where N(BrainAge45, WMH45, ArteriolRsd45, IQ45_chstd) > 0 and N(sex, bmip45, ChildIQ_chstd, NewEduc45, AUC_sys) = 5;
run;

proc means data = BP_area;
	var bmip45 ChildIQ_chstd
		i_sys7 i_sys11 i_sys18 i_sys26 i_sys32 i_sys38 i_sys45 AUC_sys
		i_dia7 i_dia11 i_dia18 i_dia26 i_dia32 i_dia38 i_dia45 AUC_dia
		BrainAge45 WMH45 ArteriolRsd45 IQ45_chstd;
		where N(BrainAge45, WMH45, ArteriolRsd45, IQ45_chstd) > 0 and N(sex, bmip45, ChildIQ_chstd, NewEduc45, AUC_sys) = 5;
run;

proc corr data = BP_area;
	var BrainAge45 WMH45 IQ45_chstd ArteriolRsd45;
	where N(BrainAge45, WMH45, ArteriolRsd45, IQ45_chstd) > 0 and N(sex, bmip45, ChildIQ_chstd, NewEduc45, AUC_sys) = 5;
run;
			
* Attrition analysis;
libname attr	"C:\Users\rh93\Box\Duke_DPPPlab\P45 Incoming\Attrition";

data attrition;
	merge BP_area 
		  attr.Seen45wscan
		  attr.P45Status_24Feb19 (keep = snum sex SESchildhd SESchildhdgp AgeatDeath44 ChildhoodIQ Dead44);
	by snum;

	insample = 0;
	if N(BrainAge45, WMH45, ArteriolRsd45, IQ45_chstd) > 0 and N(sex, bmip45, ChildIQ_chstd, NewEduc45, AUC_sys) = 5 then insample = 1;
run;

proc freq data = attrition;
	table insample;
run;

proc standard data = attrition out = attrition m = 100 sd = 15;
	var ChildhoodIQ;
run;

data attrition;
	set attrition;

	if childhoodIQ ne . and childhoodIQ < 40 then childhoodIQ = 40;
run;

proc means data = attrition n mean min q1 median q3 max;
	var childhoodIQ SESchildhd;
run;
proc means data = attrition n mean min q1 median q3 max;
	class dead44;
	var childhoodIQ SESchildhd;
run;
proc means data = attrition n mean min q1 median q3 max;
	class insample;
	var childhoodIQ SESchildhd;
run;

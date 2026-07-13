/*
  Extracted from ChiesaBP_Jan2026.sas: the sex-specific +/- 2.5 SD outlier
  screen the upstream pipeline applies to systolic / diastolic / MAP readings
  at each age wave. The mean/SD constants and the array-driven cut-off and
  flagging logic are the author's own; here they run against the mock
  BP_preMI1 built in autoexec.sas, closing with a PROC FREQ of the outlier
  indicators (as in the upstream QC block).
*/
data BP_outliers;
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

	keep snum sex
	     o_sys7 o_sys11 o_sys18 o_sys26 o_sys32 o_sys38 o_sys45
	     o_dia7 o_dia11 o_dia18 o_dia26 o_dia32 o_dia38 o_dia45
	     o_map7 o_map11 o_map18 o_map26 o_map32 o_map38 o_map45;
run;

proc freq data = BP_outliers;
	table o_sys7 o_sys45 o_dia7 o_dia45 o_map7 o_map45;
run;

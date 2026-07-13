/*
  Extracted verbatim from ChiesaBP_Jan2026.sas (data BP_area; ... run;),
  the trapezoidal area-under-the-curve quantification of cumulative early-life
  blood-pressure exposure that the manuscript's abstract describes as its AUC
  measure.

  Mock stand-in for the BP_imputed dataset produced upstream by PROC MI; the
  real imputed BP columns come from restricted-access Dunedin Study data.
  Values sit near the sex-specific cohort means the upstream script itself
  encodes as constants, so the AUC arithmetic below exercises the same code
  path on plausible inputs. Kept inline here so this script is self-contained.
*/
data BP_imputed;
    input snum sex
          i_sys7 i_sys11 i_sys18 i_sys26 i_sys32 i_sys38 i_sys45
          i_dia7 i_dia11 i_dia18 i_dia26 i_dia32 i_dia38 i_dia45
          i_map7 i_map11 i_map18 i_map26 i_map32 i_map38 i_map45;
    datalines;
1 1 101.8 103.1 115.5 111.6 112.6 116.4 117.0 61.1 68.1 56.9 69.9 73.8 75.6 76.1 74.6 79.8 76.5 83.8 86.8 89.1 89.7
2 1 104.2 106.0 118.9 114.0 115.1 119.2 120.4 63.0 70.0 59.4 71.9 76.0 77.6 78.1 76.7 82.0 79.2 85.9 89.0 91.5 92.2
3 1  99.4 101.0 112.3 108.9 110.1 113.5 114.2 59.2 66.3 54.8 67.7 71.6 73.4 74.0 72.6 77.9 74.0 81.4 84.4 86.8 87.4
4 2 102.8 103.0 125.9 121.6 122.9 124.0 125.5 61.4 67.3 57.1 73.4 77.7 80.6 84.5 75.2 79.2 79.9 89.5 92.8 95.1 98.2
5 2 105.5 106.1 129.4 125.0 126.5 127.6 129.0 63.8 69.9 59.7 76.1 80.4 83.3 87.2 77.7 82.0 82.9 92.4 95.8 98.1 101.1
6 2 100.1 100.4 122.5 118.2 119.4 120.5 122.0 59.0 64.8 54.6 70.8 75.1 78.0 81.9 72.7 76.7 77.2 86.6 89.9 92.2 95.3
7 1 107.0 108.5 121.0 117.0 118.2 122.0 123.5 64.0 71.1 60.2 72.9 77.0 79.0 79.8 78.3 83.6 80.5 87.6 90.7 93.3 94.4
8 2 103.3 104.0 126.8 122.4 123.6 124.8 126.2 62.0 68.0 57.9 74.0 78.3 81.2 85.0 75.8 80.0 80.9 90.1 93.4 95.7 98.7
;
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

proc means data = BP_area;
	var i_sys7 i_sys11 i_sys18 i_sys26 i_sys32 i_sys38 i_sys45 AUC_sys
	    i_dia7 i_dia11 i_dia18 i_dia26 i_dia32 i_dia38 i_dia45 AUC_dia
	    i_map7 i_map11 i_map18 i_map26 i_map32 i_map38 i_map45 AUC_map;
run;

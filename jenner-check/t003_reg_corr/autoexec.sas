/* cap input rows for the captured run */
options obs=100;

/*
  Mock stand-in for the BP_area analysis dataset. We supply the outcome
  (BrainAge45), the covariates the models adjust for (sex, bmip45,
  ChildIQ_chstd, NewEduc45) and the diastolic AUC exposures the regressions
  use (AUC0726_dia, AUC2645_dia), matching the columns the upstream
  PROC STANDARD / PROC REG / PROC CORR sequence reads. Values are synthetic
  but plausible; the real BP_area is derived from restricted Dunedin data.
*/
data BP_area;
    input snum sex bmip45 ChildIQ_chstd NewEduc45 BrainAge45
          AUC0726_dia AUC2645_dia AUC_dia;
    datalines;
1 1 24.1  0.42 3  1.10 1150.2  820.4 1545.9
2 1 27.3 -0.15 2  2.30 1210.5  865.1 1610.3
3 1 22.8  1.05 4 -0.80 1090.7  790.2 1480.5
4 2 29.5 -0.62 2  3.10 1305.8  930.6 1701.2
5 2 31.2 -1.10 1  4.05 1360.1  975.3 1755.8
6 2 26.7  0.20 3  0.55 1225.4  880.0 1620.7
7 1 23.9  0.88 4 -1.20 1120.9  805.5 1510.1
8 2 28.4 -0.35 2  2.75 1280.3  915.2 1675.4
9 1 25.6  0.05 3  0.90 1175.6  840.7 1560.2
10 2 30.1 -0.80 1  3.50 1330.2  950.9 1728.6
;
run;

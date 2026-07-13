/* cap input rows for the captured run */
options obs=100;

/*
  Mock stand-in for the raw BP_preMI1 dataset that upstream is built from
  BP.Chiesa_BP_forRH_march (restricted Dunedin Study data). We supply the
  sys/dia/map measurement columns across ages 7..45 plus sex, matching the
  shapes the grouping-and-outlier DATA step reads. A couple of deliberately
  extreme values exercise the +/- 2.5 SD sex-specific outlier flags.
*/
data BP_preMI1;
    input snum sex
          sys7 sys11 sys18 sys26 sys32 sys38 sys45
          dia7 dia11 dia18 dia26 dia32 dia38 dia45
          map7 map11 map18 map26 map32 map38 map45;
    datalines;
1 1 101.8 103.1 115.5 111.6 112.6 116.4 117.0 61.1 68.1 56.9 69.9 73.8 75.6 76.1 74.6 79.8 76.5 83.8 86.8 89.1 89.7
2 1 104.2 106.0 118.9 114.0 115.1 119.2 120.4 63.0 70.0 59.4 71.9 76.0 77.6 78.1 76.7 82.0 79.2 85.9 89.0 91.5 92.2
3 1  99.4 101.0 112.3 108.9 110.1 113.5 145.0 59.2 66.3 54.8 67.7 71.6 73.4 76.0 72.6 77.9 74.0 81.4 84.4 86.8 87.4
4 2 102.8 103.0 125.9 121.6 122.9 124.0 125.5 61.4 67.3 57.1 73.4 77.7 80.6 84.5 75.2 79.2 79.9 89.5 92.8 95.1 98.2
5 2 105.5 106.1 129.4 125.0 126.5 127.6 129.0 63.8 69.9 59.7 76.1 80.4 83.3 87.2 77.7 82.0 82.9 92.4 95.8 98.1 101.1
6 2  80.0 100.4 122.5 118.2 119.4 120.5 122.0 45.0 64.8 54.6 70.8 75.1 78.0 81.9 60.0 76.7 77.2 86.6 89.9 92.2 95.3
7 1 107.0 108.5 121.0 117.0 118.2 122.0 123.5 64.0 71.1 60.2 72.9 77.0 79.0 79.8 78.3 83.6 80.5 87.6 90.7 93.3 94.4
8 2 103.3 104.0 126.8 122.4 123.6 124.8 126.2 62.0 68.0 57.9 74.0 78.3 81.2 85.0 75.8 80.0 80.9 90.1 93.4 95.7 98.7
;
run;

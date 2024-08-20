*****************************************************************************************************************************************************************
**************************************************************BCS70 Blood Pressure and Cognition Analyses********************************************************
****************************************************************Mayibongwe Mugoba and Scott Chiesa 2024**********************************************************



*********************************************************************DATASET MERGING AND PREPARATION*************************************************************

cd "Y:\Dunedin Paper\Datasets"
use "bcs_age46_main.dta", clear
log using "Final Analysis", replace

*************************EARLY-LIFE FACTORS********************************

//Age and Sex//

replace BD10AGEINT = . if BD10AGEINT < 0
rename BD10AGEINT age

replace B10CMSEX = . if B10CMSEX < 0
rename B10CMSEX sex

rename BCSID bcsid
merge 1:1 bcsid using "bcs2000.dta", keepusing(ethnic)
replace ethnic = . if ethnic > 97
recode ethnic (1/3 = 0) (4/16 = 1)
label define ethnic 0 "White" 1 "Non-White", modify
label values ethnic ethnic
rename bcsid BCSID
drop if _merge == 2
drop _merge

//Birthweight//

merge 1:1 BCSID using "bcs70_1975_developmental_history.dta", keepusing(VAR5542)
drop _merge
replace VAR5542 = . if VAR5542 < 0
rename VAR5542 BW

//Childhood Socioeconomic Status//

merge 1:1 BCSID using "bcs2derived.dta", keepusing(BD2SOC)
drop _merge

replace BD2SOC = . if BD2SOC < 0
rename BD2SOC SES
drop if SES == 0

//Household Overcrowding//

rename BCSID bcsid
merge 1:1 bcsid using "f699b.dta", keepusing(e228b)
drop _merge
replace e228b = . if e228b < 0
rename e228b Overcrowding

//Age 10 Cognition//

merge 1:1 bcsid using "EarlyChildhoodCognition.dta", keepusing(harm_gc1_10 harm_gf_10 harm_gq_10 harm_gc2_10 cog_g_10)	//created using do file called Preparing Childhood Cognitive Scores//
drop if _merge == 2
drop _merge
rename bcsid BCSID

//Highest Education Level//

merge 1:1 BCSID using "bcs6derived.dta", keepusing(HIACA00)
drop _merge
replace HIACA00 = . if HIACA00 < 0
rename HIACA00 Highest_Ed
recode Highest_Ed (0 = 10) (1/2 = 11) (3/5 = 12) (6 = 13) (7/8 = 14)
label define Highest_Ed 10 "No education" 11 "Below Ordinary Secondary Education" 12 "Ordinary Secondary Qualifications" 13 "Advanced Level Qualifications" 14 "Postgraduate or Above", modify
label values Highest_Ed Highest_Ed


*************************MID-LIFE FACTORS********************************

//BMI//

replace BD10MBMI = . if BD10MBMI < 0
rename BD10MBMI Adult_BMI

//Smoking//

replace B10SMOKIG = . if B10SMOKIG < 0
rename B10SMOKIG Smoking_Status

//Malaise//

replace BD10MAL = . if BD10MAL < 0
rename BD10MAL Malaise

//Physical Activity//

merge 1:1 BCSID using "bcs_age46_activpal_avg", keepusing(B10AAMVPAH)
drop _merge
replace B10AAMVPAH = . if B10AAMVPAH < 0
rename B10AAMVPAH Activity

//Adult SES//

replace B10NSSECAN = . if B10NSSECAN < 0
recode B10NSSECAN (1.1 1.2 2 = 1) (3 4 = 2) (5/9 = 3)
rename B10NSSECAN Adult_SES
label define Adult_SES 1 "Managers" 2 "Intermediate" 3 "Lower/Technical"
label values Adult_SES Adult_SES


****************************EXPOSURES***********************************

//Age 10 Blood Pressure//

rename BCSID bcsid
merge 1:1 bcsid using "sn3723", keepusing(meb20_1 meb20_2)
drop _merge
replace meb20_1 = . if meb20_1 < 0
replace meb20_2 = . if meb20_2 < 0
rename meb20_1 Ten_Systolic
rename meb20_2 Ten_Diastolic

//Age 16 Blood Pressure//

merge 1:1 bcsid using "bcs7016x.dta", keepusing(rd5_1 rd5_2)
drop _merge 
replace rd5_1 = . if rd5_1 < 0
replace rd5_2 = . if rd5_2 < 0
rename rd5_1 Sixteen_Systolic
rename rd5_2 Sixteen_Diastolic

//Age 46 Blood Pressure//

replace B10BPSYSR2 = . if B10BPSYSR2 < 0
rename B10BPSYSR2 Second_Adult_Systolic
replace B10BPSYSR3 = . if B10BPSYSR3 < 0
rename B10BPSYSR3 Third_Adult_Systolic
replace B10BPDIAR2 = . if B10BPDIAR2 < 0
rename B10BPDIAR2 Second_Adult_Diastolic
replace B10BPDIAR3 = . if B10BPDIAR3 < 0
rename B10BPDIAR3 Third_Adult_Diastolic

gen Adult_Systolic = (Second_Adult_Systolic + Third_Adult_Systolic)/2
gen Adult_Diastolic = (Second_Adult_Diastolic + Third_Adult_Diastolic)/2

//Hypertension//

gen Adult_Hypertension = .
replace Adult_Hypertension = 1 if Adult_Systolic >=140 & Adult_Systolic != .
replace Adult_Hypertension = 1 if Adult_Diastolic >=90 & Adult_Diastolic != .
replace Adult_Hypertension = 0 if Adult_Hypertension !=1 & Adult_Systolic != . 
replace Adult_Hypertension = 0 if Adult_Hypertension !=1 & Adult_Diastolic != .
replace Adult_Hypertension = 2 if Adult_Systolic >=160  & Adult_Systolic != .
replace Adult_Hypertension = 2 if Adult_Diastolic >=100 & Adult_Diastolic != .

gen Child_Hypertension = .
replace Child_Hypertension = 1 if Ten_Systolic >=116 & Ten_Systolic != .
replace Child_Hypertension = 1 if Ten_Diastolic >=80 & Ten_Diastolic != .
replace Child_Hypertension = 0 if Child_Hypertension !=1 & Ten_Systolic != . 
replace Child_Hypertension = 0 if Child_Hypertension !=1 & Ten_Diastolic != .


****************************OUTCOMES***********************************

//Immediate and Delayed Recall//

replace B10CFLISN = . if B10CFLISN < 0
rename B10CFLISN Imm_Recall

replace B10CFLISD = . if B10CFLISD < 0
rename B10CFLISD Delay_Recall

//Processing Speed//

replace B10CFRC = . if B10CFRC < 0
rename B10CFRC Speed_Score

//Verbal Fluency//

replace B10CFANI = . if B10CFANI < 0
rename B10CFANI Verbal_Fluency

//Overall Cognition//

pca Imm_Recall Delay_Recall Verbal_Fluency Speed_Score
predict final_cog, score 
drop if final_cog ==. 

//Z-Score Variables of Interest//

zscore Ten_Systolic Ten_Diastolic Sixteen_Systolic Sixteen_Diastolic Adult_Systolic Adult_Diastolic Imm_Recall Delay_Recall Speed_Score Verbal_Fluency 

save "cleaned dataset.dta", replace


***********************************************************************DESCRIPTIVES****************************************************************

use "cleaned dataset.dta", clear

sum age BW Overcrowding cog_g_10 Adult_BMI Malaise Activity Ten_Systolic Ten_Diastolic Sixteen_Systolic Sixteen_Diastolic Adult_Systolic Adult_Diastolic final_cog Imm_Recall Delay_Recall Verbal_Fluency Speed_Score tab1 sex SES Highest_Ed Smoking_Status Adult_SES


*************************************************************************IMPUTE********************************************************************

mi set wide
mi register regular age sex z_Imm_Recall z_Delay_Recall z_Speed_Score z_Verbal_Fluency final_cog Smoking_Status
mi register imputed z_Ten_Systolic z_Ten_Diastolic z_Sixteen_Systolic z_Sixteen_Diastolic z_Adult_Systolic z_Adult_Diastolic ethnic BW SES Overcrowding cog_g_10 Highest_Ed Activity Adult_SES Malaise Adult_BMI 
mi impute chained (regress) z_Ten_Systolic z_Ten_Diastolic z_Sixteen_Systolic z_Sixteen_Diastolic z_Adult_Systolic z_Adult_Diastolic BW cog_g_10 Overcrowding Activity Malaise Adult_BMI (logit) ethnic (ologit) Adult_SES SES Highest_Ed = age sex z_Imm_Recall z_Delay_Recall z_Speed_Score z_Verbal_Fluency final_cog Smoking_Status, add(50) rseed(54321) dots

**********************************************************************PERFORM ANALYSES*************************************************************


vl create exposures = (z_Ten_Systolic z_Ten_Diastolic z_Sixteen_Systolic z_Sixteen_Diastolic z_Adult_Systolic z_Adult_Diastolic)
vl create outcomes = (final_cog z_Imm_Recall z_Delay_Recall z_Verbal_Fluency z_Speed_Score)

foreach outcome of varlist $outcomes {
	foreach exposure of varlist $exposures {
		mi estimate: regress `outcome' `exposure' age i.sex i.ethnic 
		mi estimate: regress `outcome' `exposure' age i.sex i.ethnic cog_g_10 i.SES Overcrowding i.Highest_Ed  
		mi estimate: regress `outcome' `exposure' age i.sex i.ethnic cog_g_10 SES Overcrowding i.Highest_Ed Adult_BMI i.Smoking_Status i.Adult_SES Activity Malaise 
	}
	
}

log close
clear
set more off
capture log close

*Figure 4 and Table 3

cd "/Users/lukewisniewski/Desktop/Econ 80 Research Paper/Code_Outputs"
log using synthetic_controls_decision, text replace
set scheme plotplain
local row = 2
* Export to Excel for LaTeX conversion
putexcel set synth_results, replace
putexcel B1=("Pre-Decision") C1=("Post-Decision") D1=("Post-Event")

foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct ln_ticket_price{
	use synth_data_diff_`i'.dta, replace
	capture gen year_from_relocation = _time - relocation
	capture gen year_from_decision = year_from_relocation + 5
	replace year_from_decision = -5 if (year_from_decision <-5)
	replace year_from_decision = 10 if (year_from_decision >10)
	
	capture gen real_dif = _Y_treated - _Y_synthetic
	drop if _time==.
	save temp_synth_diff_data_`i'.dta, replace
	capture egen mean_dif = mean(real_dif) if(real_dif!=.), by(year_from_decision)
	label var year_from_decision "Time"
	label var mean_dif "Average Difference"
	capture gen ci_lower = .
	capture gen ci_upper = .

	
	levelsof year_from_decision, local(years)
	foreach j of local years{
		ci mean real_dif if year_from_decision==`j', level(90)
		replace ci_lower = r(lb) if year_from_decision==`j'
		replace ci_upper = r(ub) if year_from_decision==`j'
	}
	twoway (scatter mean_dif year_from_decision) (rcap ci_lower ci_upper year_from_decision, legend(label(2 "90% CI"))), xline(-1) xline(4) yline(0)
	graph export synth_avg_diff_`i'.jpg, replace
	
	gen period=.
	replace period=1 if year_from_decision<0
	replace period=2 if year_from_decision>=0&year_from_decision<5
	replace period=3 if year_from_decision>=5
	
	collapse (mean) mean_dif (mean) period (mean) ci_lower (mean) ci_upper, by(year_from_decision)
	egen sum_real_dif=total(mean_dif), by(period)
	gen se_year = (ci_upper - ci_lower) / (2*1.645)
	egen se_period_sq = total(se_year^2), by(period)
	gen se_period = sqrt(se_period_sq)
	collapse (mean) sum_real_dif (mean) se_period, by(period)
	
	gen outcome = "`i'"
	gen mean1 = sum_real_dif[1]
    gen se1 = se_period[1]
    gen mean2 = sum_real_dif[2]
    gen se2 = se_period[2]
    gen mean3 = sum_real_dif[3]
    gen se3 = se_period[3]
	
	/*
	putexcel B`row'=(mean1)
	putexcel C`row'=(mean2)
	putexcel D`row'=(mean3)
	local row=row+1
	putexcel B`row'=(se1)
	putexcel C`row'=(se2)
	putexcel D`row'=(se3)
	*/
	levelsof outcome, local(outcomes)
	foreach o in `outcomes' {
		putexcel A`row'=("`o'")
		putexcel B`row'=(mean1)
		putexcel C`row'=(mean2)
		putexcel D`row'=(mean3)
		local row=`row' + 1
		putexcel B`row'=(se1)
		putexcel C`row'=(se2)
		putexcel D`row'=(se3)
		local row = `row' + 1
}
/*	
	* Calculate the sum and count for each group
egen sum_real_dif = total(mean_dif), by(period)
egen count = count(mean_dif), by(period)

* Calculate the mean and standard deviation
egen mean_real_dif = mean(real_dif), by(period)
egen sd_real_dif = sd(mean_dif), by(period)

* Calculate the standard error
gen se_real_dif = sd_real_dif / sqrt(count)

collapse (sum) sum_real_dif (mean) sd_real_dif (mean) se_real_dif count, by(period)
*collapse (sum) sum_real_dif (mean) mean_real_dif (sd) sd_real_dif (count) count (mean) se_real_dif, by(period)
*collapse (mean) sum_real_dif (mean) se_real_dif, by(period)

list period mean_real_dif se_real_dif
    gen outcome = "`i'"
    gen mean1 = sum_real_dif[1]
    gen se1 = se_real_dif[1]
    gen mean2 = sum_real_dif[2]
    gen se2 = se_real_dif[2]
    gen mean3 = sum_real_dif[3]
    gen se3 = se_real_dif[3]
	
	*replace mean1=mean1*5
	*replace mean2=mean2*4
	*replace mean3=mean3*6

* Loop through outcomes and write rows
levelsof outcome, local(outcomes)
foreach o in `outcomes' {
	putexcel A`row'=("`o'")
	putexcel B`row'=(mean1)
	putexcel C`row'=(mean2)
	putexcel D`row'=(mean3)
	local row=`row' + 1
	putexcel B`row'=(se1)
	putexcel C`row'=(se2)
	putexcel D`row'=(se3)
    local row = `row' + 1
}
*/

	
}

/*

foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct ln_ticket_price{
	use temp_synth_diff_data_`i'.dta, replace
	keep if team_id>100&team_id<200
	capture egen mean_dif = mean(real_dif) if (real_dif!=.), by(year_from_decision)
	label var year_from_decision "Time"
	label var mean_dif "Average Difference (MLB)"
	capture gen ci_lower = .
	capture gen ci_upper = .

	
	levelsof year_from_decision, local(years)
	foreach j of local years{
		ci mean real_dif if year_from_decision==`j', level(90)
		replace ci_lower = r(lb) if year_from_decision==`j'
		replace ci_upper = r(ub) if year_from_decision==`j'
	}
	twoway (scatter mean_dif year_from_decision) (rcap ci_lower ci_upper year_from_decision, legend(label(2 "90% CI"))), xline(-1) yline(0)
	graph export synth_avg_diff_MLB_`i'.jpg, replace
	
	use temp_synth_diff_data_`i'.dta, replace
	keep if team_id>200&team_id<300
	capture egen mean_dif = mean(real_dif) if (real_dif!=.), by(year_from_decision)
	label var year_from_decision "Time"
	label var mean_dif "Average Difference (NBA)"
	capture gen ci_lower = .
	capture gen ci_upper = .

	
	levelsof year_from_decision, local(years)
	foreach j of local years{
		ci mean real_dif if year_from_decision==`j', level(90)
		replace ci_lower = r(lb) if year_from_decision==`j'
		replace ci_upper = r(ub) if year_from_decision==`j'
	}
	twoway (scatter mean_dif year_from_decision) (rcap ci_lower ci_upper year_from_decision, legend(label(2 "90% CI"))), xline(-1) yline(0)
	graph export synth_avg_diff_NBA_`i'.jpg, replace
	
	use temp_synth_diff_data_`i'.dta, replace
	keep if team_id>300&team_id<400
	capture egen mean_dif = mean(real_dif) if (real_dif!=.), by(year_from_decision)
	label var year_from_decision "Time"
	label var mean_dif "Average Difference (NHL)"
	capture gen ci_lower = .
	capture gen ci_upper = .

	
	levelsof year_from_decision, local(years)
	foreach j of local years{
		ci mean real_dif if year_from_decision==`j', level(90)
		replace ci_lower = r(lb) if year_from_decision==`j'
		replace ci_upper = r(ub) if year_from_decision==`j'
	}
	twoway (scatter mean_dif year_from_decision) (rcap ci_lower ci_upper year_from_decision, legend(label(2 "90% CI"))), xline(-1) yline(0)
	graph export synth_avg_diff_NHL_`i'.jpg, replace
	
	use temp_synth_diff_data_`i'.dta, replace
	keep if team_id>400
	capture egen mean_dif = mean(real_dif) if (real_dif!=.), by(year_from_decision)
	label var year_from_decision "Time"
	label var mean_dif "Average Difference (NFL)"
	capture gen ci_lower = .
	capture gen ci_upper = .

	
	levelsof year_from_decision, local(years)
	foreach j of local years{
		ci mean real_dif if year_from_decision==`j', level(90)
		replace ci_lower = r(lb) if year_from_decision==`j'
		replace ci_upper = r(ub) if year_from_decision==`j'
	}
	twoway (scatter mean_dif year_from_decision) (rcap ci_lower ci_upper year_from_decision, legend(label(2 "90% CI"))), xline(-1) yline(0)
	graph export synth_avg_diff_NFL_`i'.jpg, replace
}


/*
foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct{
use synth_data_`i'.dta, replace
capture gen year_from_decision = _time - relocation
replace year_from_decision = -5 if (_time - relocation) <=-5
replace year_from_decision = 10 if (_time - relocation) >=10

capture gen real_dif = _Y_treated - _Y_synthetic
drop if _time==.

capture egen mean_dif = mean(real_dif) if(real_dif!=.), by(year_from_decision)
label var year_from_decision "Time"
label var mean_dif "Average Difference"


save temp_synth_diff_data_`i', replace

clear
set obs 0
gen lower_ci=.
gen upper_ci=.
gen dummy=.
save temp_results_`i'.dta, replace

use temp_synth_diff_data_`i', clear
levelsof year_from_decision, local(years)
foreach j of local years{
	use temp_synth_diff_data_`i', clear
	scalar drop _all
	bootstrap mean_b=r(mean), reps(10000) level(90) saving(results_`i'_`j', replace): summ real_dif if year_from_decision ==`j'
	scalar lower_ci = r(table)[5,1]
	scalar upper_ci = r(table)[6,1]
	
	clear
	set obs 1
	use results_`i'_`j', clear
	gen lower_ci = scalar(lower_ci)
	gen upper_ci = scalar(upper_ci)
	gen dummy =`j'
	collapse (mean) mean_b lower_ci upper_ci dummy
	save results_`i'_`j'.dta, replace
	clear
	append using temp_results_`i'.dta results_`i'_`j'.dta
	save temp_results_`i'.dta, replace
	use temp_synth_diff_data_`i'.dta, replace
	gen dummy=year_from_decision
	merge m:1 dummy using temp_results_`i'.dta

}
save temp_results_`i'.dta, replace
use temp_results_`i', clear



twoway (scatter mean_dif year_from_decision) (rcap lower_ci upper_ci year_from_decision), xline(-1) yline(0)
graph export synth_avg_diff_`i'.jpg, replace
}
*/
*/
log close

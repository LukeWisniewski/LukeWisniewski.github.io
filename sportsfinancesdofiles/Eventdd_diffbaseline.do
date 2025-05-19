clear
set more off
capture log close

*Figures 2 and 3, as well as Table 2

global directory "/Users/lukewisniewski/Desktop/Econ 80 Research Paper"
*******************************************************************************
************************ ALTERNATIVE BASELINE SPECIFICATIONS ******************
*******************************************************************************
clear
cd "$directory"
use "$directory/Dta_Files/complete_data.dta", replace
cd "$directory/Code_Outputs"
global team_controls "msa_pop incomepc totincome i.canada i.two_team"
set scheme plotplain
global keeplist_dd "lead* lag*"

log using eventdd_difbaseline, text replace
drop if year>=2023
replace new_stad=0 if mover==1
replace move_stad=. if new_stad==0

save temp_teamdata, replace



xtset team_id year
****************************** Revenue Growth *********************************
* Relocating Franchises *
save temp_teamdata, replace
eventdd ln_revenue i.year##i.league, timevar(move_year) method(fe) graph_op(ytitle("Average Revenue Growth") xlabel(-10(1)10)) baseline(-5) noline leads(10) lags(10) accum keepdummies
outreg2 using fin_sev.tex, replace word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_revenue i.year##i.league $team_controls, timevar(move_year) baseline(-5) noline method(fe) graph_op(ytitle("Average Revenue Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
graph export rel_rev_sev.jpg, replace
outreg2 using fin_sev.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead10 +lead9+ lead8+lead7 +lead6
local coef1=r(estimate)
local se1=r(se)
lincom lead4+lead3+lead2+lead1
local coef2=r(estimate)
local se2=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef3=r(estimate)
local se3=r(se)
testparm lead10-lead6
testparm lead4-lead1
testparm lag*
foreach i in $keeplist_dd{
	drop `i'
}


* New Stadia Franchises *
save temp_teamdata, replace
eventdd ln_revenue i.year##i.league, timevar(move_stad) method(fe) baseline(-5) noline graph_op(ytitle("Average Revenue Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
outreg2 using fin_sev.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_revenue i.year##i.league $team_controls, timevar(move_stad) baseline(-5) noline method(fe) graph_op(ytitle("Average Revenue Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
graph export stad_rev_sev.jpg, replace
outreg2 using fin_sev.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)

lincom lead10 +lead9+ lead8+lead7 +lead6
local coef4=r(estimate)
local se4=r(se)
lincom lead4+lead3+lead2+lead1
local coef5=r(estimate)
local se5=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef6=r(estimate)
local se6=r(se)

testparm lead10-lead6
testparm lead4-lead1
testparm lag*
foreach i in $keeplist_dd{
	drop `i'
}

matrix results = (`coef1', `coef2', `coef3', `coef4', `coef5', `coef6' \ `se1', `se2', `se3', `se4', `se5', `se6')
eststo clear  // Clear any previous stored results
estadd matrix Coef = results[1,1...]  // Add coefficients
estadd matrix SE = results[2,1...]    // Add standard errors
eststo results1  // Store the first result set
putexcel set table_2_results, replace
putexcel B1=("Pre-Decision")
putexcel C1=("Post-Decision")
putexcel D1=("Post-Event")
putexcel E1=("Pre-Decision")
putexcel F1=("Post-Decision")
putexcel G1=("Post-Event")
putexcel A2=("Revenue")
putexcel B2=matrix(results)



***************************** Attendance Growth *******************************
* Relocating Franchises *
save temp_teamdata, replace
eventdd ln_avg_attendance i.year##i.league, timevar(move_year) method(fe) baseline(-5) noline graph_op(ytitle("Average Attendance Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
outreg2 using fan_sev.tex, replace word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_avg_attendance i.year##i.league $team_controls, timevar(move_year) method(fe) baseline(-5) noline graph_op(ytitle("Average Attendance Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
graph export rel_attendance_sev.jpg, replace
outreg2 using fan_sev.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead10 +lead9+ lead8+lead7 +lead6
local coef1=r(estimate)
local se1=r(se)
lincom lead4+lead3+lead2+lead1
local coef2=r(estimate)
local se2=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef3=r(estimate)
local se3=r(se)
testparm lead10-lead6
testparm lead4-lead1
testparm lag*
foreach i in $keeplist_dd{
	drop `i'
}

* New Stadia Franchises *
save temp_teamdata, replace
eventdd ln_avg_attendance i.year##i.league, timevar(move_stad) method(fe) baseline(-5) noline graph_op(ytitle("Average Attendance Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
outreg2 using fan_sev.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_avg_attendance i.year##i.league $team_controls, timevar(move_stad) method(fe) baseline(-5) noline graph_op(ytitle("Average Attendance Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
graph export stad_attendance_sev.jpg, replace
outreg2 using fan_sev.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead10 +lead9+ lead8+lead7 +lead6
local coef4=r(estimate)
local se4=r(se)
lincom lead4+lead3+lead2+lead1
local coef5=r(estimate)
local se5=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef6=r(estimate)
local se6=r(se)
testparm lead10-lead6
testparm lead4-lead1
testparm lag*
foreach i in $keeplist_dd{
	drop `i'
}

matrix results = (`coef1', `coef2', `coef3', `coef4', `coef5', `coef6' \ `se1', `se2', `se3', `se4', `se5', `se6')
estadd matrix Coef = results[1,1...]  // Add coefficients
estadd matrix SE = results[2,1...]    // Add standard errors
eststo results2
putexcel A4=("Attendance")
putexcel B4=matrix(results)

*********************** Revenue over Expenditure Growth ***********************
* Relocating Franchises *
save temp_teamdata, replace
eventdd ln_revexpratio i.year##i.league, timevar(move_year) method(fe) baseline(-5) noline graph_op(ytitle("Average Revenue to Expenditure Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
outreg2 using fin_sev.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_revexpratio i.year##i.league $team_controls, timevar(move_year) method(fe) baseline(-5) noline graph_op(ytitle("Average Revenue to Expenditure Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
graph export rel_revex_sev.jpg, replace
outreg2 using fin_sev.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead10 +lead9+ lead8+lead7 +lead6
local coef1=r(estimate)
local se1=r(se)
lincom lead4+lead3+lead2+lead1
local coef2=r(estimate)
local se2=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef3=r(estimate)
local se3=r(se)
testparm lead10-lead6
testparm lead4-lead1
testparm lag*
foreach i in $keeplist_dd{
	drop `i'
}

* New Stadia Franchises *
save temp_teamdata, replace
eventdd ln_revexpratio i.year##i.league, timevar(move_stad) method(fe) baseline(-5) noline graph_op(ytitle("Average Revenue to Expenditure Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
outreg2 using fin_sev.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_revexpratio i.year##i.league $team_controls, timevar(move_stad) method(fe) baseline(-5) noline graph_op(ytitle("Average Revenue to Expenditure Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
graph export stad_revex_sev.jpg, replace
outreg2 using fin_sev.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead10 +lead9+ lead8+lead7 +lead6
local coef4=r(estimate)
local se4=r(se)
lincom lead4+lead3+lead2+lead1
local coef5=r(estimate)
local se5=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef6=r(estimate)
local se6=r(se)
testparm lead10-lead6
testparm lead4-lead1
testparm lag*
foreach i in $keeplist_dd{
	drop `i'
}
matrix results = (`coef1', `coef2', `coef3', `coef4', `coef5', `coef6' \ `se1', `se2', `se3', `se4', `se5', `se6')
estadd matrix Coef = results[1,1...]  // Add coefficients
estadd matrix SE = results[2,1...]    // Add standard errors
eststo results3
putexcel A6=("Revenue/Expenditure")
putexcel B6=matrix(results)

****************************** Salary Growth **********************************
* Relocating Franchises *
save temp_teamdata, replace
eventdd ln_salary i.year##i.league, timevar(move_year) method(fe) baseline(-5) noline graph_op(ytitle("Average Salary Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
outreg2 using fin_sev.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_salary i.year##i.league $team_controls, timevar(move_year) method(fe) baseline(-5) noline graph_op(ytitle("Average Salary Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
graph export rel_salary_sev.jpg, replace
outreg2 using fin_sev.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead10 +lead9+ lead8+lead7 +lead6
local coef1=r(estimate)
local se1=r(se)
lincom lead4+lead3+lead2+lead1
local coef2=r(estimate)
local se2=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef3=r(estimate)
local se3=r(se)
testparm lead10-lead6
testparm lead4-lead1
testparm lag*
foreach i in $keeplist_dd{
	drop `i'
}

* New Stadia Franchises *
save temp_teamdata, replace
eventdd ln_salary i.year##i.league, timevar(move_stad) method(fe) baseline(-5) noline graph_op(ytitle("Average Salary Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
outreg2 using fin_sev.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_salary i.year##i.league $team_controls, timevar(move_stad) method(fe) baseline(-5) noline graph_op(ytitle("Average Salary Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
graph export stad_salary_sev.jpg, replace
outreg2 using fin_sev.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead10 +lead9+ lead8+lead7 +lead6
local coef4=r(estimate)
local se4=r(se)
lincom lead4+lead3+lead2+lead1
local coef5=r(estimate)
local se5=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef6=r(estimate)
local se6=r(se)
testparm lead10-lead6
testparm lead4-lead1
testparm lag*
foreach i in $keeplist_dd{
	drop `i'
}
matrix results = (`coef1', `coef2', `coef3', `coef4', `coef5', `coef6' \ `se1', `se2', `se3', `se4', `se5', `se6')
estadd matrix Coef = results[1,1...]  // Add coefficients
estadd matrix SE = results[2,1...]    // Add standard errors
eststo results4
putexcel A8=("Salary")
putexcel B8=matrix(results)


*************************** Win Percentage Growth ****************************
* Relocating Franchises *
save temp_teamdata, replace
eventdd std_pct i.year##i.league, timevar(move_year) method(fe) baseline(-5) noline graph_op(ytitle("Average Win Percentage Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
outreg2 using fan_sev.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd std_pct i.year##i.league $team_controls, timevar(move_year) method(fe) baseline(-5) noline graph_op(ytitle("Average Win Percentage Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
graph export rel_pct_sev.jpg, replace
outreg2 using fan_sev.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead10 +lead9+ lead8+lead7 +lead6
local coef1=r(estimate)
local se1=r(se)
lincom lead4+lead3+lead2+lead1
local coef2=r(estimate)
local se2=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef3=r(estimate)
local se3=r(se)
testparm lead10-lead6
testparm lead4-lead1
testparm lag*
foreach i in $keeplist_dd{
	drop `i'
}


* New Stadia Franchises *
save temp_teamdata, replace
eventdd std_pct i.year##i.league, timevar(move_stad) method(fe) baseline(-5) noline graph_op(ytitle("Average Win Percentage Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
outreg2 using fan_sev.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd std_pct i.year##i.league $team_controls, timevar(move_stad) method(fe) baseline(-5) noline graph_op(ytitle("Average Win Percentage Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
graph export stad_pct_sev.jpg, replace
outreg2 using fan_sev.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead10 +lead9+ lead8+lead7 +lead6
local coef4=r(estimate)
local se4=r(se)
lincom lead4+lead3+lead2+lead1
local coef5=r(estimate)
local se5=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef6=r(estimate)
local se6=r(se)
testparm lead10-lead6
testparm lead4-lead1
testparm lag*
foreach i in $keeplist_dd{
	drop `i'
}
matrix results = (`coef1', `coef2', `coef3', `coef4', `coef5', `coef6' \ `se1', `se2', `se3', `se4', `se5', `se6')
estadd matrix Coef = results[1,1...]  // Add coefficients
estadd matrix SE = results[2,1...]    // Add standard errors
eststo results5
putexcel A10=("Winning Percentage")
putexcel B10=matrix(results)

****************************** Ticket Price Growth ****************************
* Relocating Franchises *
save temp_teamdata, replace
eventdd ln_ticket_price i.year##i.league, timevar(move_year) method(fe) baseline(-5) noline graph_op(ytitle("Average Ticket Price Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
outreg2 using fan_sev.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_ticket_price i.year##i.league $team_controls, timevar(move_year) method(fe) baseline(-5) noline graph_op(ytitle("Average Ticket Price Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
graph export rel_tick_sev.jpg, replace
outreg2 using fan_sev.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead10 +lead9+ lead8+lead7 +lead6
local coef1=r(estimate)
local se1=r(se)
lincom lead4+lead3+lead2+lead1
local coef2=r(estimate)
local se2=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef3=r(estimate)
local se3=r(se)
testparm lead10-lead6
testparm lead4-lead1
testparm lag*
foreach i in $keeplist_dd{
	drop `i'
}


* New Stadia Franchises *
save temp_teamdata, replace
eventdd ln_ticket_price i.year##i.league, timevar(move_stad) method(fe) baseline(-5) noline graph_op(ytitle("Average Ticket Price Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
outreg2 using fan_sev.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_ticket_price i.year##i.league $team_controls, timevar(move_stad) method(fe) baseline(-5) noline graph_op(ytitle("Average Ticket Price Growth") xlabel(-10(1)10)) leads(10) lags(10) accum keepdummies
graph export stad_tick_sev.jpg, replace
outreg2 using fan_sev.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead10 +lead9+ lead8+lead7 +lead6
local coef4=r(estimate)
local se4=r(se)
lincom lead4+lead3+lead2+lead1
local coef5=r(estimate)
local se5=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef6=r(estimate)
local se6=r(se)
testparm lead10-lead6
testparm lead4-lead1
testparm lag*
foreach i in $keeplist_dd{
	drop `i'
}

matrix results = (`coef1', `coef2', `coef3', `coef4', `coef5', `coef6' \ `se1', `se2', `se3', `se4', `se5', `se6')
estadd matrix Coef = results[1,1...]  // Add coefficients
estadd matrix SE = results[2,1...]    // Add standard errors
eststo results6
putexcel A12=("Ticket Price")
putexcel B12=matrix(results)


*esttab results1 results2 results3 results4 results5 results6 using "table_2_results.tex", replace

log close


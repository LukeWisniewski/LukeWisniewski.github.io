clear
set more off
capture log close

** MAIN REGRESSION SPECIFICATION
*Table A2, Figures A1 and A2

global directory "/Users/lukewisniewski/Desktop/Econ 80 Research Paper"
*******************************************************************************
*******************************************************************************
cd "$directory"
use "$directory/Dta_Files/complete_data.dta", replace
cd "$directory/Code_Outputs"
log using eventdd_short_time_frame, text replace

set scheme plotplain
global team_controls "msa_pop incomepc totincome i.canada i.two_team"

global keeplist_dd "lead* lag*"

drop if year>=2023

replace new_stad=0 if mover==1
replace move_stad=. if new_stad==0


ssc install eventdd, replace
ssc install matsort, replace
save temp_teamdata.dta, replace
xtset team_id year


****************** SPECIFICATION 2: Eliminating Movers as Stad ****************

****************************** Revenue Growth *********************************
* Relocating Franchises *
save temp_teamdata, replace
eventdd ln_revenue i.year##i.league prev_pct, timevar(move_year) method(fe) graph_op(ytitle("Average Revenue Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fin_real.tex, replace word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_revenue i.year##i.league $team_controls prev_pct, timevar(move_year) method(fe) graph_op(ytitle("Average Revenue Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export rel_rev_real.jpg, replace
outreg2 using fin_real.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead5+lead4+lead3+lead2
local coef1=r(estimate)
local se1=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef2=r(estimate)
local se2=r(se)
foreach i in $keeplist_dd{
	drop `i'
}

* New Stadia Franchises *
save temp_teamdata, replace
eventdd ln_revenue i.year##i.league prev_pct, timevar(move_stad) method(fe) graph_op(ytitle("Average Revenue Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fin_real.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_revenue i.year##i.league $team_controls prev_pct, timevar(move_stad) method(fe) graph_op(ytitle("Average Revenue Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export stad_rev_real.jpg, replace
outreg2 using fin_real.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead5+lead4+lead3+lead2
local coef3=r(estimate)
local se3=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef4=r(estimate)
local se4=r(se)
foreach i in $keeplist_dd{
	drop `i'
}
matrix results = (`coef1', `coef2', `coef3', `coef4' \ `se1', `se2', `se3', `se4')
putexcel set table_short_results, replace
putexcel B1=("Pre-Event")
putexcel C1=("Post-Event")
putexcel D1=("Pre-Event")
putexcel E1=("Post-Event")
putexcel A2=("Revenue")
putexcel B2=matrix(results)

***************************** Attendance Growth *******************************
* Relocating Franchises *
save temp_teamdata, replace
eventdd ln_avg_attendance i.year##i.league prev_pct, timevar(move_year) method(fe) graph_op(ytitle("Average Attendance Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fan_real.tex, replace word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_avg_attendance i.year##i.league $team_controls prev_pct, timevar(move_year) method(fe) graph_op(ytitle("Average Attendance Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export rel_attendance_real.jpg, replace
outreg2 using fan_real.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead5+lead4+lead3+lead2
local coef1=r(estimate)
local se1=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef2=r(estimate)
local se2=r(se)
foreach i in $keeplist_dd{
	drop `i'
}

* New Stadia Franchises *
save temp_teamdata, replace
eventdd ln_avg_attendance i.year##i.league prev_pct, timevar(move_stad) method(fe) graph_op(ytitle("Average Attendance Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fan_real.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_avg_attendance i.year##i.league $team_controls prev_pct, timevar(move_stad) method(fe) graph_op(ytitle("Average Attendance Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export stad_attendance_real.jpg, replace
outreg2 using fan_real.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead5+lead4+lead3+lead2
local coef3=r(estimate)
local se3=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef4=r(estimate)
local se4=r(se)
foreach i in $keeplist_dd{
	drop `i'
}
matrix results = (`coef1', `coef2', `coef3', `coef4' \ `se1', `se2', `se3', `se4')
putexcel A4=("Attendance")
putexcel B4=matrix(results)

*********************** Revenue over Expenditure Growth ***********************
* Relocating Franchises *
save temp_teamdata,replace
eventdd ln_revexpratio i.year##i.league, timevar(move_year) method(fe) graph_op(ytitle("Average Revenue to Expenditure Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fin_real.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_revexpratio i.year##i.league $team_controls, timevar(move_year) method(fe) graph_op(ytitle("Average Revenue to Expenditure Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export rel_revex_real.jpg, replace
outreg2 using fin_real.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead5+lead4+lead3+lead2
local coef1=r(estimate)
local se1=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef2=r(estimate)
local se2=r(se)
foreach i in $keeplist_dd{
	drop `i'
}

* New Stadia Franchises *
save temp_teamdata, replace
eventdd ln_revexpratio i.year##i.league, timevar(move_stad) method(fe) graph_op(ytitle("Average Revenue to Expenditure Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fin_real.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_revexpratio i.year##i.league $team_controls, timevar(move_stad) method(fe) graph_op(ytitle("Average Revenue to Expenditure Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export stad_revex_real.jpg, replace
outreg2 using fin_real.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead5+lead4+lead3+lead2
local coef3=r(estimate)
local se3=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef4=r(estimate)
local se4=r(se)
foreach i in $keeplist_dd{
	drop `i'
}
matrix results = (`coef1', `coef2', `coef3', `coef4' \ `se1', `se2', `se3', `se4')
putexcel A6=("Revenue/Expenditure")
putexcel B6=matrix(results)

****************************** Salary Growth **********************************
* Relocating Franchises *
save temp_teamdata, replace
eventdd ln_salary i.year##i.league, timevar(move_year) method(fe) graph_op(ytitle("Average Salary Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fin_real.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_salary i.year##i.league $team_controls, timevar(move_year) method(fe) graph_op(ytitle("Average Salary Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export rel_salary_real.jpg, replace
outreg2 using fin_real.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead5+lead4+lead3+lead2
local coef1=r(estimate)
local se1=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef2=r(estimate)
local se2=r(se)
foreach i in $keeplist_dd{
	drop `i'
}

* New Stadia Franchises *
save temp_teamdata, replace
eventdd ln_salary i.year##i.league, timevar(move_stad) method(fe) graph_op(ytitle("Average Salary Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fin_real.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_salary i.year##i.league $team_controls, timevar(move_stad) method(fe) graph_op(ytitle("Average Salary Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export stad_salary_real.jpg, replace
outreg2 using fin_real.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead5+lead4+lead3+lead2
local coef3=r(estimate)
local se3=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef4=r(estimate)
local se4=r(se)
foreach i in $keeplist_dd{
	drop `i'
}
matrix results = (`coef1', `coef2', `coef3', `coef4' \ `se1', `se2', `se3', `se4')
putexcel A8=("Salary")
putexcel B8=matrix(results)

*************************** Win Percentage Growth ****************************
* Relocating Franchises *
save temp_teamdata, replace
eventdd std_pct i.year##i.league, timevar(move_year) method(fe) graph_op(ytitle("Average Win Percentage Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fan_real.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd std_pct i.year##i.league $team_controls, timevar(move_year) method(fe) graph_op(ytitle("Average Win Percentage Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export rel_pct_real.jpg, replace
outreg2 using fan_real.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead5+lead4+lead3+lead2
local coef1=r(estimate)
local se1=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef2=r(estimate)
local se2=r(se)
foreach i in $keeplist_dd{
	drop `i'
}


* New Stadia Franchises *
save temp_teamdata, replace
eventdd std_pct i.year##i.league, timevar(move_stad) method(fe) graph_op(ytitle("Average Win Percentage Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fan_real.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd std_pct i.year##i.league $team_controls, timevar(move_stad) method(fe) graph_op(ytitle("Average Win Percentage Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export stad_pct_real.jpg, replace
outreg2 using fan_real.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead5+lead4+lead3+lead2
local coef3=r(estimate)
local se3=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef4=r(estimate)
local se4=r(se)
foreach i in $keeplist_dd{
	drop `i'
}
matrix results = (`coef1', `coef2', `coef3', `coef4' \ `se1', `se2', `se3', `se4')
putexcel A10=("Winning Percentage")
putexcel B10=matrix(results)

**************************** Ticket Price Growth ******************************
* Relocating Franchises *
save temp_teamdata, replace
eventdd ln_ticket_price i.year##i.league, timevar(move_year) method(fe) graph_op(ytitle("Average Ticket Price Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fan_real.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_ticket_price i.year##i.league $team_controls, timevar(move_year) method(fe) graph_op(ytitle("Average Ticket Price Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export rel_tick_real.jpg, replace
outreg2 using fan_real.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead5+lead4+lead3+lead2
local coef1=r(estimate)
local se1=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef2=r(estimate)
local se2=r(se)
foreach i in $keeplist_dd{
	drop `i'
}


* New Stadia Franchises *
save temp_teamdata, replace
eventdd ln_ticket_price i.year##i.league, timevar(move_stad) method(fe) graph_op(ytitle("Average Ticket Price Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fan_real.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_ticket_price i.year##i.league $team_controls, timevar(move_stad) method(fe) graph_op(ytitle("Average Ticket Price Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export stad_tick_real.jpg, replace
outreg2 using fan_real.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
lincom lead5+lead4+lead3+lead2
local coef3=r(estimate)
local se3=r(se)
lincom lag0+lag1+lag2+lag3+lag4+lag5+lag6+lag7+lag8+lag9+lag10
local coef4=r(estimate)
local se4=r(se)
foreach i in $keeplist_dd{
	drop `i'
}
matrix results = (`coef1', `coef2', `coef3', `coef4' \ `se1', `se2', `se3', `se4')
putexcel A12=("Ticket Price")
putexcel B12=matrix(results)





log close

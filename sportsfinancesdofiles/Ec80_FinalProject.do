clear
set more off
capture log close

global directory "/Users/lukewisniewski/Desktop/Econ 80 Research Paper"
cd "$directory"
set scheme plotplain
use "$directory/Dta_Files/complete_data.dta"

cd "$directory/Code_Outputs"

/*
global move_dummies "move_m3less move_m2 move_m1 move_1 move_2 move_3 move_4 move_5 move_6 move_7 move_8 move_9 move_10p"

global stad_dummies "stad_m3less stad_m2 stad_m1 stad_1 stad_2 stad_3 stad_4 stad_5 stad_6 stad_7 stad_8 stad_9 stad_10p"
*/

global team_controls "msa_pop incomepc totincome i.canada i.two_team"

global keeplist_dd "lead* lag*"

log using econ_80_final_project, text replace
drop if year>=2023



outsum revenue salary other_expenses revexpratio avg_attendance ticket_price msa_pop incomepc totincome wpct canada two_team expansion mover new_stad using final_balance.tex if league==1, comma replace ctitle(NFL)

outsum revenue salary other_expenses revexpratio avg_attendance ticket_price msa_pop incomepc totincome wpct canada two_team expansion mover new_stad using final_balance.tex if league==2, comma append ctitle(NHL)

outsum revenue salary other_expenses revexpratio avg_attendance ticket_price msa_pop incomepc totincome wpct canada two_team expansion mover new_stad using final_balance.tex if league==3, comma append ctitle(NBA)

outsum revenue salary other_expenses revexpratio avg_attendance ticket_price msa_pop incomepc totincome wpct canada two_team expansion mover new_stad using final_balance.tex if league==4, comma append ctitle(MLB)


save temp_teamdata.dta, replace

/*
*******************************************************************************
***************************** DIF-IN-DIF MODELS *******************************
*******************************************************************************
reg ln_salary postm mover post_move i.year $team_controls, cluster(league)


reg ln_salary $move_dummies i.year##i.league from_canada msa_pop incomepc totincome two_team, robust
reg ln_salary $stad_dummies i.year##i.league msa_pop incomepc totincome two_team, robust

reg ln_revenue $move_dummies i.year##i.league from_canada msa_pop incomepc totincome two_team, robust
reg ln_revenue $stad_dummies i.year##i.league msa_pop incomepc totincome two_team, robust

reg ln_avg_attendance $move_dummies i.year##i.league from_canada msa_pop incomepc totincome two_team, robust
reg ln_avg_attendance $stad_dummies i.year##i.league msa_pop incomepc totincome two_team, robust

reg ln_revexpratio $move_dummies i.year##i.league from_canada msa_pop incomepc totincome two_team, robust
reg ln_revexpratio $stad_dummies i.year##i.league msa_pop incomepc totincome two_team, robust

reg ln_other_expenses $move_dummies i.year##i.league from_canada msa_pop incomepc totincome two_team, robust
reg ln_other_expenses $stad_dummies i.year##i.league msa_pop incomepc totincome two_team, robust

reg std_pct $move_dummies i.year##i.league from_canada msa_pop incomepc totincome two_team, robust
reg std_pct $stad_dummies i.year##i.league msa_pop incomepc totincome two_team, robust
*/

*******************************************************************************
***************************** EVENT STUDY MODEL *******************************
*******************************************************************************
ssc install eventdd, replace
ssc install matsort, replace
xtset team_id year

********** SPECIFICATION 1: MOVERS vs. NON-MOVERS, STAD vs. NON-STAD **********
****************************** Revenue Growth *********************************
* Relocating Franchises *
save temp_teamdata, replace
eventdd ln_revenue i.year, timevar(move_year) method(fe) graph_op(ytitle("Average Revenue Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
testparm lead*
testparm lag*
outreg2 using fin.tex, replace word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_revenue i.year $team_controls, timevar(move_year) method(fe) graph_op(ytitle("Average Revenue Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
testparm lead*
testparm lag*
graph export rel_rev.jpg, replace
outreg2 using fin.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
foreach i in $keeplist_dd{
	drop `i'
}

* New Stadia Franchises *
save temp_teamdata, replace
eventdd ln_revenue i.year, timevar(move_stad) method(fe) graph_op(ytitle("Average Revenue Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
testparm lead*
testparm lag*
outreg2 using fin.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_revenue i.year $team_controls, timevar(move_stad) method(fe) graph_op(ytitle("Average Revenue Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
testparm lead*
testparm lag*
graph export stad_rev.jpg, replace
outreg2 using fin.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
foreach i in $keeplist_dd{
	drop `i'
}

***************************** Attendance Growth *******************************
* Relocating Franchises *
save temp_teamdata, replace
eventdd ln_avg_attendance i.year, timevar(move_year) method(fe) graph_op(ytitle("Average Attendance Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fan.tex, replace word label keep($keeplist_dd) 
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_avg_attendance i.year $team_controls, timevar(move_year) method(fe) graph_op(ytitle("Average Attendance Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export rel_attendance.jpg, replace
outreg2 using fan.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
foreach i in $keeplist_dd{
	drop `i'
}

* New Stadia Franchises *
save temp_teamdata, replace
eventdd ln_avg_attendance i.year, timevar(move_stad) method(fe) graph_op(ytitle("Average Attendance Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fan.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace

eventdd ln_avg_attendance i.year $team_controls, timevar(move_stad) method(fe) graph_op(ytitle("Average Attendance Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export stad_attendance.jpg, replace
outreg2 using fan.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
foreach i in $keeplist_dd{
	drop `i'
}

*********************** Revenue over Expenditure Growth ***********************
* Relocating Franchises *
save temp_teamdata,replace
eventdd ln_revexpratio i.year, timevar(move_year) method(fe) graph_op(ytitle("Average Revenue to Expenditure Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fin.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_revexpratio i.year $team_controls, timevar(move_year) method(fe) graph_op(ytitle("Average Revenue to Expenditure Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export rel_revex.jpg, replace
outreg2 using fin.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
foreach i in $keeplist_dd{
	drop `i'
}

* New Stadia Franchises *
save temp_teamdata, replace
eventdd ln_revexpratio i.year, timevar(move_stad) method(fe) graph_op(ytitle("Average Revenue to Expenditure Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fin.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_revexpratio i.year $team_controls, timevar(move_stad) method(fe) graph_op(ytitle("Average Revenue to Expenditure Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export stad_revex.jpg, replace
outreg2 using fin.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
foreach i in $keeplist_dd{
	drop `i'
}

****************************** Salary Growth **********************************
* Relocating Franchises *
save temp_teamdata, replace
eventdd ln_salary i.year, timevar(move_year) method(fe) graph_op(ytitle("Average Salary Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fin.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_salary i.year $team_controls, timevar(move_year) method(fe) graph_op(ytitle("Average Salary Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export rel_salary.jpg, replace
outreg2 using fin.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
foreach i in $keeplist_dd{
	drop `i'
}

* New Stadia Franchises *
save temp_teamdata, replace
eventdd ln_salary i.year, timevar(move_stad) method(fe) graph_op(ytitle("Average Salary Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fin.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_salary i.year $team_controls, timevar(move_stad) method(fe) graph_op(ytitle("Average Salary Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export stad_salary.jpg, replace
outreg2 using fin.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
foreach i in $keeplist_dd{
	drop `i'
}

*************************** Win Percentage Growth ****************************
* Relocating Franchises *
save temp_teamdata, replace
eventdd std_pct i.year, timevar(move_year) method(fe) graph_op(ytitle("Average Win Percentage Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fan.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd std_pct i.year $team_controls, timevar(move_year) method(fe) graph_op(ytitle("Average Win Percentage Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export rel_pct.jpg, replace
outreg2 using fan.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
foreach i in $keeplist_dd{
	drop `i'
}


* New Stadia Franchises *
save temp_teamdata, replace
eventdd std_pct i.year, timevar(move_stad) method(fe) graph_op(ytitle("Average Win Percentage Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fan.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd std_pct i.year $team_controls, timevar(move_stad) method(fe) graph_op(ytitle("Average Win Percentage Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export stad_pct.jpg, replace
outreg2 using fan.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
foreach i in $keeplist_dd{
	drop `i'
}




log close


clear
set more off
capture log close

global directory "/Users/lukewisniewski/Desktop/Econ 80 Research Paper"
cd "$directory"

cd "$directory/Dta_Files"

drop _all
tempfile cumulator
quietly save `cumulator', emptyok

foreach i in mlb nba nhl nfl{
	import excel using `i'_full_data.xlsx, sheet(Sheet1) firstrow clear
	append using `cumulator'
	quietly save `cumulator', replace
}

drop T-AL


gen mover = (yr_of_move_1!=.)
gen move_year = year-yr_of_move_1
*replace move_year = -5 if yr_of_move_1 ==.

/*
gen move_m3less = move_year<=-3
gen move_m2 = move_year==-2
gen move_m1 = move_year==-1
forval i = 0/9{
	gen move_`i' = move_year==`i'
}
gen move_10p = move_year>=10
*/

gen new_stad = yr_of_new_stadium!=.
gen move_stad = year-yr_of_new_stadium
/*
*replace move_stad = -5 if yr_of_new_stadium ==.
gen stad_m3less = move_stad<=-3
gen stad_m2 = move_stad==-2
gen stad_m1 = move_stad==-1
forval i = 0/9{
	gen stad_`i'= move_stad == `i'
}
gen stad_10p = move_stad>=10
*/
gen temp_sal = salary/(10^6)

drop salary

gen salary = temp_sal
drop temp_sal

gen other_expenses = revenue - salary - profit

gen revexpratio = revenue / (other_expenses+salary)

foreach i in revenue salary other_expenses revexpratio avg_attendance ticket_price{
	gen ln_`i' = ln(`i')
}

label var salary "salary (million USD)"
label var revenue "revenue (million USD)"
label var profit "operating costs (million USD)"
label var ticket_price "Average Home Ticket Price"


label define league_num 1 "nfl" 2 "nhl" 3 "nba" 4 "mlb" 5 "missing"
label val league league_num

drop if year==.


sort league year msa_id team_id

by league year msa_id: gen team_id_prev = team_id[_n-1]
by league year msa_id: gen team_id_next= team_id[_n+1]
gen two_team = 0
by league year msa_id: replace two_team = 1 if team_id_prev!=. | team_id_next!=.
drop team_id_prev team_id_next

bysort league: egen mean_wpct = mean(wpct)
bysort league: egen sd_wpct = sd(wpct)

gen std_pct = (wpct-mean_wpct)/ sd_wpct
label var std_pct "Winning Percentage (Standard Deviations from League Mean)"
label var wpct "Winning Percentage"
label var ln_revenue "Revenue"
label var ln_salary "Salary"
label var ln_other_expenses "Other Expenses"
label var ln_revexpratio "Revenue to Expense Ratio"
label var ln_avg_attendance "Average Home Attendance"
label var two_team "City with Two Franchises"
label var msa_pop "MSA Population"
label var incomepc "MSA Income Per Capita"
label var mover "Relocating Franchise"
label var new_stad "Reinvesting Franchise"


sort league team_id year-yr_of_move_1
by league team_id: gen prev_pct = std_pct[_n-1] if year == year[_n-1] + 1

gen canada = 0
replace canada = 1 if msa_id==52|msa_id==26|msa_id==32|msa_id==47|msa_id==50|msa_id==5|msa_id==14|msa_id==48

label var canada "Canada"


gen post_move = (year>=yr_of_move_1) if yr_of_move_1!=.

gen post_stad = (year>=yr_of_new_stadium) if yr_of_new_stadium!=.


gen totincome = (msa_pop * incomepc) / 10^6
label var totincome "Population*Income PC"

* Creating expansion indicator variable *
sort team_id year
bysort team_id: gen first_year = (year==year[1])
gen expansion = (year!=1990 & first_year==1)
bysort team_id: replace expansion=expansion[1]
drop first_year
label var expansion "Expansion Franchise (1990-2023)"


save complete_data.dta, replace

summ


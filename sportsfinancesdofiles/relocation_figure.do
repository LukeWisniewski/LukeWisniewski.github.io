clear
set more off
capture log close

* Figure 1

global directory "/Users/lukewisniewski/Desktop/Econ 80 Research Paper"
cd "$directory/Dta_Files"
log using fig1, text replace
set scheme plotplain

import excel using all_relocations.xlsx, firstrow clear

gen time = floor(year / 5) * 5
collapse (count) year, by(time)

graph bar year, over(time) ytitle("Number of Relocations: 1950-2025")

graph export num_relocations.jpg, replace

log close

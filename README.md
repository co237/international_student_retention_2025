# Replicating international student retention estimates

These estimates use two datasets to calculate international student retention: [IPEDS' Statistical Tables](https://nces.ed.gov/ipeds/datacenter/Statistics.aspx?sid=f81e2202-0244-4bac-ac99-b1f833b5c679&rtid=3)  and the latest [National Survey of College Graduates](https://ncses.nsf.gov/surveys/national-survey-college-graduates/2023) microdata.

IPEDS: Using the statistical tables, filter for all schools within the 50 states and D.C. This should yield 5,994 schols. 
Variable selection: Under "Completions," choose "Number of students receiving awards/degrees, by award level, race/ethnicity, gender and age" for academic years 2011-12 through 2020-21. Select totals for the bachelor's, master's, and doctoral degree levels. Then select "Nonresident alien total." This will give you the total graduates on temporary visas (not green cards). 

NSCG: Use the following filters in the microdata:
MRYR >2011, MRYR < 2022: To filter for graduates who earned their most recent degree between 2012 and 2021. 

FNVSATP == 3: To filter for international graduates who first came to the U.S. on a student visa. 

MRDG >0 & MRDG <4: To filter for those whose most recent degrees were at the BA, MA, or PhD levels.

MRST_TOGA == 099: To filter for those who earned their most recent degree in the United States. 

This will give you the total number of recent international student graduates who still live in the U.S. 

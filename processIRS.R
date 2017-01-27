# process IRS data the way I want

# desired features: 
# 1) % of returns from 1 - $25k
# 2) % of returns from $25 - $50k
# 3) % of returns from $50 - $75k
# 4) % of returns from $75 - $100k
# 5) % of returns from $100 - $200k
# 6) % of returns from $200k up
# 6a) % of single returns (MARS1)
# 6b) % of join returns (MARS2)
# 6c) % of head of household returns (MARS4)
# 6d) % of returns with paid preparer's signature (PREP)
# 6e) # of exemptions/# of returns (N2)
# 6f) # of dependents/# of returns (NUMDEP)
# 6g) % of total volunteer prepared returns (TOTAL_VITA)
# 6h) % of Volunteer prepared returns among AGI <$50k (VITA)
# 6i) % of returns with salaries and wwages (N00200)
# 6j) % of returns with taxable interest (N00300)
# 6k) % of returns with ordinary dividends (N00600)
# 6l) % of returns with qualified dividends (N00650)
# 6m) % of returns with business or pro net income (N00900)
# 6n) % of returns with net capital gain (N01000)
# 6o) % of returns with taxable ind. retirement arrangements
#     distributions (N01400)
# 6p) % of returns with taxable pensions and annuities (N01700)
# 7) % of total returns with unemployment compensation (N02300)
# 8) % of total returns with taxable social security benefits (NO2500)
# 9) % of total returns with educator expenses (NO3220)
# 10) % of total returns with self-employment health insurance deduction
#     (NO3270)
# 11) % of total returns with IRA payments (N03150)
# 12) % of total returns with student loan interest deductions (N03210)
# 13) % of total returns with tuition and fees deductions (NO3230)
# 14) % of total returns with real estate taxes (N18500)
# 15) # of total returns with taxes paid (N18300) / # of total returns
#     with taxable income (N04800) (or maybe should divide by #
#     of returns with tax liability? N10300) or tax due at time of
#     filing? N11901
# 16) % of total returns with mortgage interest paid (N19300)
# 17) % of total returns with contributions (N19700)
# 18) % of returns with alternative minimum tax (N09600)
# 19) % of returns with foreign tax credit
# 20) % of returns with child and dependent care credit (N07180)
# 21) % of returns with nonrefundable education credit (N07230)
# 22) % of returns with retirement savings contributiong credit (N07240)
# 23) % of returns with child tax credits (N07220)
# 24) % of returns with residential energy tax credit (N07260)
# 25) % of returns with self-employment tax (N09400)
# 26) % of returns with total premium tax credit [health care] (N85770)
# 27) % of returns with advance premium tax credit (N85775)
# 28) % of returns with health care individual responsibility payment
#     (N09750)
# 29) % of returns with AGI under $50k with earned income tax credit
#     (N59660)
# 30) # of returns with excess earned income credit (N59720) / 
#     # of returns with earned income credit (N59660)
# 31) % of returns with AGI under $75k with additional child tax credit
#     (N11070)
# 32) % of returns with AGI under $200k with refundable education credit  
#     (N10960)
# 33) % of returns with AGI under $50k with net premium tax credit  
#     (N11560) [health insurance]
# 34) % of returns with AGI over $200k with additional Medicare tax
#     (N85530)
# 35) % of returns with net investment income tax (over $200k?)
#     (N85300)
# 36) % of returns with overpayments refunded (N11902)

rm(list=ls())

## Create initial data table

zip.pops <- read.csv("2010_census_zips.csv")
$ontext
CEE 5410/6410 - Water Resources Systems Analysis
Problem 2.3 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)

THE PROBLEM (As quoted from the text):

An aqueduct constructed to supply water to industrial users has an excess
capacity in the months of June, July, and August of 14,000 ac-ft, 18,000 ac-ft,
and 6,000 ac-ft, respectively. It is proposed to develop not more than
10,000 acres of new land by utilizing the excess aqueduct capacity for
irrigation water deliveries. Two crops, hay and grain, are to be grown. Their
monthly water requirements and expected net returns are given in the following
table.



Determine the optimal planting for the two crops to maximize profit.

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

Code was adapated from an example created by David E Rosenberg
(https://github.com/dzeke/CEE-6410-Rosenberg/blob/master/Lectures/Ex2-1.gms)

Joshua T Ward
joshua.timothy.ward@aggiemail.usu.edu / joshua.ward@usu.edu
September 23, 2020
$offtext

* 1. DEFINE the SETS
SETS crop crops grown /Hay, Grain/
     res resources /Land "Land Area", W6 "June Water", W7 "July Water", W8 "August Water"/;

* 2. DEFINE input data
PARAMETERS
   c(crop) Objective function coefficients ($ per plant)
         /Hay 100,
         Grain 120/
   b(res) Right hand constraint values (per resource)
          /Land 10000,
           W6 14000,
           W7 18000,
           W8  6000/;

TABLE A(crop,res) Left hand side constraint coefficients
              Land       W6      W7      W8
 Hay          1          2       1       1
 Grain        1          1       2       0 ;

* 3. DEFINE the variables
VARIABLES X(crop) crop planted (Number)
          VPROFIT  total profit ($);

* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT Total profit ($) and objective function value
   RES_CONSTRAIN(res) Resource Constraints;

PROFIT..                 VPROFIT =E= SUM(crop,c(crop)*X(crop));
RES_CONSTRAIN(res) ..    SUM(crop,A(crop,res)*X(crop)) =L= b(res);

* 5. DEFINE the MODEL from the EQUATIONS
MODEL PLANTING /PROFIT, RES_CONSTRAIN/;
*Altnerative way to write (include all previously defined equations)
*MODEL PLANTING /ALL/;

* 6. SOLVE the MODEL
* Solve the PLANTING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PLANTING USING LP MAXIMIZING VPROFIT;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file

Execute_Unload "JTW_HW3.gdx";

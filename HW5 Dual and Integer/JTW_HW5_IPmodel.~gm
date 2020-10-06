$ontext
CEE 5410 - Water Resources Systems Analysis
Dual Formation of a Reservoir optimization problem for HW5

THE PROBLEM:

A FARMER PLANS TO DEVELOP WATER FORIRRIGATION. HE IS CONSIDERING TWO POSSIBLE
SOURCES OF WATER: A GRAVITY DIVERSION FROM A POSSIBLE RESERVOIR WITH TWO
ALTERNATIVE CPACITIES AND/OR A PUMP FROM A LOWER RIVER DIVERSION (REFER TO
FIGURE 7.3). BETWEEN THE RESERVOIR AND PUMP SITE THE RIVER BASE FLOW INCREASES
BY 2 ACFT/DAY DUE TO GROUNDWATER DRAINAGE INTO THE RIVER. IGNORE LOSSES FROM
THE RESERVOIR. THE RIVER FLOW INTO THE RESERVOIR AND THE FARMER'S DEMAND DURING
EACH OF THE TWO SIX-MONTH SEASONS OF THE YEAR ARE GIVEN IN TABLE 7.5. REVENUE
IS ESTIMATED AT $300 PER YEAR PER ACRE IRRIGATED.

SEASONAL FLOW AND DEMAND

SEASON   RIVER INFLOW Qt (acft)  IRRIGATION DEMAND (acft/acre)
1        600                     1.0
2        200                     3.0

ASSUME THERE ARE ONLY TWO POSSIBLE SIZES OF RESERVOIR: A HIGH DAM THAT HAS
CAPACITY OF 700 acft OR A LOW DAM WITH CAPACITY OF 300 acft. THE CAPITATL COSTS
ARE $10,000/YR AND $6,000/YR FOR THE HIGH AND LOW DAMS, RESPECTIVELY (NO
OPERATING COST). THE PUMP CAPACITY IS FIXED AT 2.2 acft/day WITH A CAPITAL COST
(IF BUILT) OF $8,000/YR AND OPERATING COST OF $20/acft.

DEVELOP A MIXED INTEGER PROGRAMMING MODEL FOR THIS PROBLEM AND SOLVE.

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

Joshua T Ward
joshua.timothy.ward@aggiemail.usu.edu / joshua.ward@usu.edu

October 5, 2020
$offtext
* Define the problem dimensions with sets

SETS     t season /t1, t2/
         l Location /res "Reservoir", far "Farm Diversion", riv "River Release", pmp "Pumped from River"/
         s Size of reservoir built /nb "No-Build",low "Low Dam", hi "High Dam"/;

PARAMETERS    Inflow(t) River inflow (ac-ft) by season t /t1 600, t2 200/
              I_Dem(t) Irrigation demand (ac-ft per acre) by season t /t1 1.0, t2 3.0/
              R_Cap_Cost(s) Capital costs per build alternative ($ per year) /nb 0, low 6000, hi 10000/
              R_Op_Cost(s) Operating costs per build alternative ($ per year) /nb 0, low 0, hi 0/
              R_Cap(s) Reservoir capacity (acft) /nb 0, low 300, hi 700/;

SCALAR
         P_Cap Capacity of pump (ac-ft per day) / 2.2 /
         P_Op_Cost Annual operating costs of pump ($ per ac-ft) / 20 /
         P_Cap_Cost Annual capital cost of building the pump ($ per year) / 8000 /
         B Annual (per year) benefits derived from irrigation ($ per acre) / 300 /
         GW_Drain Drainage from groundwater to river (ac-ft) / 2.0 /;

VARIABLES I(s) Binary decision multiplier for size of reservoir project
          J Binary decision multiplier for decision to install pump or not
          X(l, t) Water allocations (ac-ft) by location and season
          A Area of irrigated farmland (acre)
          VPROFIT Value of net benefits ($);

BINARY VARIABLES I, J;
POSITIVE VARIABLES X, A;

* Define and build constraint equations
EQUATIONS
         RES_CAP(t) Reservoir storage must be less than capacity in all time steps
         MB_RES_S1 Mass balance in the reservoir must be observed in season 1
         MB_RES_S2 Mass balance in the reservoir must be observed in season 2
         MB_RIVER(t) Pump cannot extract more water than is available in the river
         IRR_DEM(t) Area irrigated by water cannot exceed supply for all seasons
         BLD_DEC Only one build decision is permitted for the reservoir
         PMP_CAP(t) Pump will be used at or below capacity for all seasons

         PROFIT Net benefits ($ Earned - $ Cost);

* Build the constraint equations
RES_CAP(t)..                X("res", t) =L= SUM(s, R_Cap(s)*I(s));
MB_RES_S1..                 X("res", "t1") =E= Inflow("t1") + 0 - X("riv", "t1") - X("far", "t1");
MB_RES_S2..                 X("res", "t2") =E= Inflow("t2") + X("res", "t1") - X("riv", "t2")-X("far", "t2");
MB_RIVER(t)..               X("riv", t) + GW_DRAIN*365/2 - X("pmp", t) =G= 0;
IRR_DEM(t)..                A =L= (X("far", t) + X("pmp", t))/I_Dem(t);
BLD_DEC..                   SUM(s,I(s)) =E= 1;
PMP_CAP(t)..                X("pmp", t) =L= J * P_Cap * 365/2;

* Build the objective function
PROFIT..                 VPROFIT =E= A * B - SUM(s, R_Cap_Cost(s)*I(s)) - J * P_Cap_Cost - SUM(t, X("pmp", t) * P_Op_Cost)

MODEL RES_MODEL /ALL/;

SOLVE RES_MODEL USING MIP MAXIMIZING VPROFIT;

* RES_MODEL.OptFile=1;

EXECUTE_UNLOAD "JTW_HW5_IP.gdx";

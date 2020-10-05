$ontext
CEE 5410 - Water Resources Systems Analysis
Dual Formation of a Reservoir optimization problem for HW5

THE PROBLEM:

A reservoir must maintain 5 units of water of storage at the end
of an irrigation period. A water manager must decide how much to release through
the turbines, how much to retain in the reservoir, and how much to irrigate a
large area of farmland while maintaining a flow of 1 unit in the river at the
end of the system. Data are as follows:

Month    Inflow Units    Hydro Benefits ($/unit) Irr. Benefits ($/Unit)
1        2               1.6                     1.0
2        2               1.7                     1.2
3        3               1.8                     1.9
4        4               1.9                     2.0
5        5               2.0                     2.2
5        6               2.0                     2.2

The optimization depends on both the storage location and time (month scale)
Decision Variables
VRes(t) - Storage volume of the reservoir (Units), for all t
VSpill - Volume released via the spillway (Units), for all t
VTurb - Volume released via the hydropower turbines (Units), for all t
VIrr - Volume diverted to irrigated farmland (Units), for all t
VRiver - Volume over the course of each month left in the river (Units), for all t

Objective Function
Primal - Maximize benefits derived from hydropower and irrigation
Dual   - Minimize costs per resource

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

Joshua T Ward
joshua.timothy.ward@aggiemail.usu.edu / joshua.ward@usu.edu

October 5, 2020
$offtext

*Define the sets containing decision variables and resource constraints
SETS L Water allocation locations in reservoir system
         /res "Reservoir", sp "Spillway", hyd "Hydropower", irr "Irrigation", riv "River"/
     t Month of period of interest
         /M1, M2, M3, M4, M5, M6/
     con Constraints for dual formulation
         /res_mb "Reservoir Mass Balance", div_mb "Diversion Point Mass Balance", riv_flo "Minimum streamflow",
          hyd_flo "Turbine Capacity", res_cap "Reservoir Capacity", res_sus "Storage Net Increase"/;

* Define the bounds of the constraint inequalities
SCALAR
         BEG_STO Beginning reservoir storage at start of model period (units of water) / 5 /
         RES_MAX Maximum reservoir capacity (units of water) / 9 /
         TUR_MAX Maximum flow through the turbines (units of water) / 4 /
         RIV_MIN Minimum flow required in the river after diversion point B (units of water) / 1 /;

*Define the parameters and coefficients
PARAMETERS
         I(t) Inflow values in each month t (units of water)
         /M1 2, M2 2, M3 3, M4 4, M5 3, M6 2/

$ontext
TABLE
c(L, t) Objective function coefficients at location L in month t ($ per unit)
         M1      M2      M3      M4      M5      M6
hyd      1.6     1.7     1.8     1.9     2.0     2.0
irr      1.0     1.2     1.9     2.0     2.2     2.2
res      0       0       0       0       0       0
sp       0       0       0       0       0       0
riv      0       0       0       0       0       0       ;
$offtext

TABLE cT(t, L) Objective function coefficients ($ per unit)
         hyd     irr     res     sp      riv
M1       1.6     1.0     0       0       0
M2       1.7     1.2     0       0       0
M3       1.8     1.9     0       0       0
M4       1.9     2.0     0       0       0
M5       2.0     2.2     0       0       0
M6       2.0     2.2     0       0       0       ;

TABLE BP_Con(t, con) B (RHS) vector on constraints in the primal form
         res_mb  div_mb  riv_flo hyd_flo res_cap res_sus
M1       7       0       1       4       9       0
M2       2       0       1       4       9       0
M3       3       0       1       4       9       0
M4       4       0       1       4       9       0
M5       5       0       1       4       9       0
M6       6       0       1       4       9       5;

$ontext
        X is the vector of decision variables in the primal formulation
        Y is the vector of decision variables in the dual formulation (reduced costs of the primal)

$offtext

VARIABLES
*         X(L, t) water allocations by site and month (units of water)
          Y(t, con) reduced costs by month and constraint ($ per unit of water)

*         VPROFIT total profit in primal form ($)
          VRC_DUAL total rediced cost in dual form ($);

*Define non-negativity constraints on the variables
* POSITIVE VARIABLES X;
POSITIVE VARIABLES Y;

$ontext
First block: Define the equations used in the primal
Second block: Define the equations used in the dual
Third block: Build the constraint equations used in the primal
Fourth block: Build the constraint equations used in the dual
$offtext
EQUATIONS
$ontext
         PROFIT Total profit ($) and objective function value of primal

         IRES_MASSBAL Initial reservoir mass balance (units of water)
         RESERVE_MASSBAL(t) Reservoir mass balance (units of water)
         DIVERT_MASSBAL(t) Mass balance at diversion point B (units of water)
         FLOW_RIVER(t) Minimum flow requirement in river (units of water)
         RESERVE_STORAGE(t) Reservoir net change in storage (units of water)
         TURBINE_CAP(t) Hydropower capacity of reservoir turbines (units of water)
         RESERVE_CAP(t) Reservoir capacity (units of water)
$offtext
         REDCOST(t) Reduced cost ($) and objective function value of dual

         D_Xres(t) Reduced cost constraints for reservoir mass balance variables (M1-M5)
         D_XresF Reduced cost constraints for reservoir mass balance variable (M6)
         D_Xsp(t) Reduced cost constraints for spillway releases for all t
         D_Xhyd(t) Reduced cost constraints for hydropower releases for all t
         D_Xirr(t) Reduced cost constraints for irrigation releases for all t
         D_Xriv(t) Reduced cost constraints for streamflow levels for all t  ;

* Build the constraint equations for the primal
$ontext
Primal Decision Variables are Dual Constraints

IRES_MASSBAL..                           BEG_STO+I("M1")-X("sp","M1")-X("hyd","M1") =E= X("res","M1");
RESERVE_MASSBAL(t)$(ORD(t) ge 2 )..      I(t)+X("res",t-1)-X("sp",t)-X("hyd", t) =E= X("res",t);
DIVERT_MASSBAL(t) ..                     X("hyd",t)+X("sp",t)-X("irr",t)-X("riv",t) =E= 0;
FLOW_RIVER(t) ..                         X("riv",t) =G= RIV_MIN;
RESERVE_STORAGE(t) ..                    X("res","M6") =G= BEG_STO;
TURBINE_CAP(t) ..                        X("hyd", t) =L= TUR_MAX;
RESERVE_CAP(t) ..                        X("res",t) =L= RES_MAX;
$offtext

* Build the constraint equations for the dual
* Dual constraints =

  D_Xres(t)$(ORD(t) le 5 )..             Y(t, "res_mb")-Y(t+1, "res_mb")+Y(t, "res_cap") =G= cT(t, "res");
  D_XresF..                              Y("M6", "res_mb")+Y("M6", "res_cap")+Y("M6","res_sus") =G= cT("M6", "res");
  D_Xhyd(t)..                            Y(t, "res_mb")+Y(t, "div_mb")+Y(t, "hyd_flo") =G= cT(t, "hyd");
  D_Xsp(t)..                             Y(t, "res_mb")+Y(t, "div_mb") =G= cT(t, "sp");
  D_Xirr(t)..                           -Y(t, "div_mb") =G= cT(t, "irr");
  D_Xriv(t)..                           -Y(t, "div_mb") + Y(t, "riv_flo") =G= cT(t, "riv");

* Build the objective function
* PROFIT..                     VPROFIT =E= SUM(t, c("hyd",t)*X("hyd",t)+c("irr",t)*X("irr",t)) ;
  REDCOST(t)..                 VRC_DUAL =E= SUM(con, Y(t, con)*BP_Con(t, con)) ;


* Include all equations in the model
* MODEL PRIMAL /ALL/;

MODEL DUAL /ALL/ ;

DUAL.OptFile=1;

* Solve the model
* SOLVE RES USING LP MAXIMIZING VPROFIT;
SOLVE DUAL USING LP MINIMIZING VRC_DUAL;

* Save a gdx file for easier viewing of the tables
EXECUTE_UNLOAD "JTW_HW5_DUAL.gdx";

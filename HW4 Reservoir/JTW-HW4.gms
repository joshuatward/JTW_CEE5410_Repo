$ontext
CEE 5410 - Water Resources Systems Analysis
Reservoir Optimazation problem for HW4

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
Maximize benefits derived from hydropower and irrigation


THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

Joshua T Ward
joshua.ward@usu.edu

September 21, 2020
$offtext


*Define the sets containing decision variables and resource constraints
SETS L Water allocation locations in reservoir system
         /res "Reservoir", sp "Spillway", hyd "Hydropower", irr "Irrigation", riv "River"/
     t Month of period of interest
         /M1, M2, M3, M4, M5, M6/;

*Define the parameters and coefficients
PARAMETERS

TABLE
     benefits(L, t) Benefits produced at location L in month t
         M1      M2      M3      M4      M5      M6
hyd      1.6     1.7     1.8     1.9     2.0     2.0
irr      1.0     1.2     1.9     2.0     2.2     2.2








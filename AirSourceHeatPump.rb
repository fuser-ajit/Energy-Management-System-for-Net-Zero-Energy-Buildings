<%#INITIALIZE
parameter "zone_name"

parameter "heating_setpoint", :default=>70|'F'
parameter "cooling_setpoint", :default=>75|'F'

parameter "heating_setpoint_sch", :default=>nil
parameter "cooling_setpoint_sch", :default=>nil

parameter "oa_method", :default=>"Sum"
parameter "oa_person", :default=>0|'CFM'
parameter "oa_area", :default=>0|'CFM/ft2'
parameter "oa_zone", :default=>0|'CFM'

parameter "cooling_coil_cop", :default=>3.23

parameter "heating_coil_cop", :default=>2.75

parameter "hp_supply_max_temp", :default=>105|'F'    # used with ashp
parameter "hp_supp_heat_max_temp", :default=>50|'F'    # used with ashp
parameter "hp_min_temp", :default=>0|'F'    # used with ashp
parameter "hp_defrost_temp", :default=>40|'F'    # used with ashp

parameter "crankcase_max_temp", :default=>50|'F'
parameter "crankcase_cap", :default=>50|'W'

parameter "fan_eff_supply", :default=>0.65
parameter "fan_rise_supply", :default=>1.0|'in H2O'

parameter "exhaust_fan", :default=>false
parameter "exhaust_fan_eff", :default=>0.25
parameter "exhaust_fan_rise", :default=>1.0|'in H2O'
parameter "exhaust_fan_flow", :default=>0.0|'CFM'

parameter "operation_schedule", :default=>
"
  Through: 12/31,          !- Field 1
  For: AllDays,            !- Field 2
  Until: 24:00, 1.0;       !- Field 3
"

parameter "clear_water_storage_tank", :default=>"" # variable used to create tank to store clear water as cooling coil condensate
parameter "clear_water_supply_tank", :default=>"" # variable used to create tank to supply clear water for evaporative cooling

%>

Sizing:Zone,
  <%= zone_name %>,        !- Zone or ZoneList Name
  SupplyAirTemperature,    !- Zone Cooling Design Supply Air Temperature Input Method
  12.78,                   !- Zone Cooling Design Supply Air Temperature {C}
  ,                        !- Zone Cooling Design Supply Air Temperature Difference {deltaC}
  SupplyAirTemperature,    !- Zone Heating Design Supply Air Temperature Input Method
  45,                      !- Zone Heating Design Supply Air Temperature {C}
  ,                        !- Zone Heating Design Supply Air Temperature Difference {deltaC}
  0.0085,                  !- Zone Cooling Design Supply Air Humidity Ratio {kgWater/kgDryAir}
  0.0080,                  !- Zone Heating Design Supply Air Humidity Ratio {kgWater/kgDryAir}
  <%= zone_name %> Design OA,  !- Design Specification Outdoor Air Object Name
  ,                        !- Zone Heating Sizing Factor
  ,                        !- Zone Cooling Sizing Factor
  DesignDay,               !- Cooling Design Air Flow Method
  ,                        !- Cooling Design Air Flow Rate {m3/s}
  ,                        !- Cooling Minimum Air Flow per Zone Floor Area {m3/s-m2}
  ,                        !- Cooling Minimum Air Flow {m3/s}
  ,                        !- Cooling Minimum Air Flow Fraction
  DesignDay,               !- Heating Design Air Flow Method
  ,                        !- Heating Design Air Flow Rate {m3/s}
  ,                        !- Heating Maximum Air Flow per Zone Floor Area {m3/s-m2}
  ,                        !- Heating Maximum Air Flow {m3/s}
  ;                        !- Heating Maximum Air Flow Fraction

DesignSpecification:OutdoorAir,
  <%= zone_name %> Design OA,  !- Name
  <%= oa_method %>,            !- Outdoor Air Method
  <%= oa_person %>,            !- Outdoor Air Flow per Person {m3/s-person}
  <%= oa_area %>,              !- Outdoor Air Flow per Zone Floor Area {m3/s-m2}
  <%= oa_zone %>;              !- Outdoor Air Flow per Zone {m3/s}

ZoneControl:Thermostat,
  <%= zone_name %> Thermostat,  !- Name
  <%= zone_name %>,    !- Zone or ZoneList Name
  <%= zone_name %> Thermostat Type Sched,  !- Control Type Schedule Name
  ThermostatSetpoint:DualSetpoint,  !- Control 1 Object Type
  <%= zone_name %> Setpoints;  !- Control 1 Name

Schedule:Constant,
  <%= zone_name %> Thermostat Type Sched,  !- Name
  Control Type,            !- Schedule Type Limits Name
  4;                       !- Hourly Value

ThermostatSetpoint:DualSetpoint,
  <%= zone_name %> Setpoints,  !- Name
  <%= zone_name %> Heating Setpoint Sch,  !- Heating Setpoint Temperature Schedule Name
  <%= zone_name %> Cooling Setpoint Sch;  !- Cooling Setpoint Temperature Schedule Name

<% if (heating_setpoint_sch) %>
Schedule:Compact,
  <%= zone_name %> Heating Setpoint Sch,  !- Name
  Any Number,              !- Schedule Type Limits Name
<%= heating_setpoint_sch %>
<% else %>
Schedule:Constant,
  <%= zone_name %> Heating Setpoint Sch,  !- Name
  Any Number,              !- Schedule Type Limits Name
  <%= heating_setpoint %>;  !- Hourly Value
<% end %>

<% if (cooling_setpoint_sch) %>
Schedule:Compact,
  <%= zone_name %> Cooling Setpoint Sch,  !- Name
  Any Number,              !- Schedule Type Limits Name
<%= cooling_setpoint_sch %>
<% else %>
Schedule:Constant,
  <%= zone_name %> Cooling Setpoint Sch,  !- Name
  Any Number,              !- Schedule Type Limits Name
  <%= cooling_setpoint %>;  !- Hourly Value
<% end %>

Schedule:Compact,
  <%= zone_name %> Operation Schedule,  !- Name
  On/Off,                  !- Schedule Type Limits Name
<%= operation_schedule %>

ZoneHVAC:EquipmentConnections,
  <%= zone_name %>,        !- Zone Name
  <%= zone_name %> Equipment,  !- Zone Conditioning Equipment List Name
  <%= zone_name %> Inlet Nodes,  !- Zone Air Inlet Node or NodeList Name
  <%= zone_name %> Exhaust Nodes,  !- Zone Air Exhaust Node or NodeList Name
  <%= zone_name %> Air Node,  !- Zone Air Node Name
  <%= zone_name %> Return Air Node;  !- Zone Return Air Node Name

NodeList,
  <%= zone_name %> Inlet Nodes,  !- Name
  <%= zone_name %> Air Outlet Node;  !- Node 1 Name

NodeList,
  <%= zone_name %> Exhaust Nodes,    !- Name
<% if (exhaust_fan) %>
  <%= zone_name %> Exhaust Fan Inlet Node,  !- Node 1 Name
<% end %>
  <%= zone_name %> Air Inlet Node;  !- Node 1 Name

<% if (exhaust_fan) %>
ZoneHVAC:EquipmentList,
  <%= zone_name %> Equipment,  !- Name
  SequentialLoad,  !- Load Distribution Scheme
  Fan:ZoneExhaust,         !- Zone Equipment 1 Object Type
  <%= zone_name %> Exhaust Fan,  !- Zone Equipment 1 Name
  1,                       !- Zone Equipment 1 Cooling Sequence
  1,                       !- Zone Equipment 1 Heating or No-Load Sequence
  ,                        !- Zone Equipment 1 Sequential Cooling Fraction
  ,                        !- Zone Equipment 1 Sequential Heating Fraction
  ZoneHVAC:PackagedTerminalHeatPump,  !- Zone Equipment 2 Object Type
  <%= zone_name %> Heat Pump,  !- Zone Equipment 2 Name
  2,                       !- Zone Equipment 2 Cooling Sequence
  2,                       !- Zone Equipment 2 Heating or No-Load Sequence
  ,                        !- Zone Equipment 2 Sequential Cooling Fraction
  ;                        !- Zone Equipment 2 Sequential Heating Fraction
<% else %>
ZoneHVAC:EquipmentList,
  <%= zone_name %> Equipment,  !- Name
  SequentialLoad,  !- Load Distribution Scheme
  ZoneHVAC:PackagedTerminalHeatPump,  !- Zone Equipment 1 Object Type
  <%= zone_name %> Heat Pump,  !- Zone Equipment 1 Name
  1,                       !- Zone Equipment 1 Cooling Sequence
  1,                       !- Zone Equipment 1 Heating or No-Load Sequence
  ,                        !- Zone Equipment 1 Sequential Cooling Fraction
  ;                        !- Zone Equipment 1 Sequential Heating Fraction
<% end %>

ZoneHVAC:PackagedTerminalHeatPump,
  <%= zone_name %> Heat Pump,         !- Name
  <%= zone_name %> Operation Schedule,  !- Availability Schedule Name
  <%= zone_name %> Air Inlet Node,  !- Air Inlet Node Name
  <%= zone_name %> Air Outlet Node,  !- Air Outlet Node Name
  OutdoorAir:Mixer, !- Outdoor Air Mixer Object Type
  <%= zone_name %> OA Mixer, !- Outdoor Air Mixer Name
  Autosize, !- Supply Air Flow Rate During Cooling Operation {m3/s}
  Autosize, !- Supply Air Flow Rate During Heating Operation {m3/s}
  Autosize, !- Supply Air Flow Rate When No Cooling or Heating is Needed {m3/s}
  Autosize, !- Outdoor Air Flow Rate During Cooling Operation {m3/s}
  Autosize, !- Outdoor Air Flow Rate During Heating Operation {m3/s}
  Autosize, !- Outdoor Air Flow Rate When No Cooling or Heating is Needed {m3/s}
  Fan:OnOff, !- Supply Air Fan Object Type
  <%= zone_name %> Heat Pump Fan, !- Supply Air Fan Name
  Coil:Heating:DX:SingleSpeed, !- Heating Coil Object Type
  <%= zone_name %> Heating Coil, !- Heating Coil Name
  0.001, !- Heating Convergence Tolerance {dimensionless}
  Coil:Cooling:DX:SingleSpeed, !- Cooling Coil Object Type
  <%= zone_name %> Cooling Coil, !- Cooling Coil Name
  0.001, !- Cooling Convergence Tolerance {dimensionless}
  Coil:Heating:Electric, !- Supplemental Heating Coil Object Type
  <%= zone_name %> Supp Heating Coil, !- Supplemental Heating Coil Name
  Autosize, !- Maximum Supply Air Temperature from Supplemental Heater {C}
  10.0, !- Maximum Outdoor Dry-Bulb Temperature for Supplemental Heater Operation {C}
  DrawThrough, !- Fan Placement
  <%= zone_name %> Fan Operation Schedule; !- Supply Air Fan Operating Mode Schedule Name

Schedule:Constant,
  <%= zone_name %> Fan Operation Schedule,  !- Name
  Any Number,                    !- Schedule Type Limits Name
  0;                             !- Hourly Value

OutdoorAir:Node,
  <%= zone_name %> Outside Air Inlet Node;  !- Name

OutdoorAir:Mixer,
  <%= zone_name %> OA Mixer, !- Name
  <%= zone_name %> OA Outlet Node, !- Mixed Air Node Name
  <%= zone_name %> Outside Air Inlet Node, !- Outdoor Air Stream Node Name
  <%= zone_name %> OA Relief Node, !- Relief Air Stream Node Name
  <%= zone_name %> Air Inlet Node; !- Return Air Stream Node Name

Coil:Cooling:DX:SingleSpeed,
  <%= zone_name %> Cooling Coil,  !- Name
  <%= zone_name %> Operation Schedule,  !- Availability Schedule Name
  Autosize,                   !- Rated High Speed Total Cooling Capacity {W}
  Autosize,                  !- Rated High Speed Sensible Heat Ratio
  <%= cooling_coil_cop %>,   !- Rated High Speed COP
  Autosize,                  !- Rated High Speed Air Flow Rate {m^3/s}
  ,                          !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m^3/s)}
  <%= zone_name %> OA Outlet Node,  !- Air Inlet Node Name
  <%= zone_name %> Cooling Coil Outlet Node,  !- Air Outlet Node Name
  <%= zone_name %> Cool-Cap-fT,  !- Total Cooling Capacity Function of Temperature Curve Name
  <%= zone_name %> Cool-Cap-fFF,  !- Total Cooling Capacity Function of Flow Fraction Curve Name
  <%= zone_name %> Cool-EIR-fT,  !- Energy Input Ratio Function of Temperature Curve Name
  <%= zone_name %> Cool-EIR-fFF,  !- Energy Input Ratio Function of Flow Fraction Curve Name
  <%= zone_name %> Cool-PLF-fPLR,  !- Part Load Fraction Correlation Curve Name
  -25.0,                     !- Minimum Outdoor Dry-Bulb Temperature for Compressor Operation (C)
  1000,                      !- Nominal Time for Condensate Removal to Begin {s}
  1.5,                       !- Ratio of Initial Moisture Evaporation Rate and Steady State Latent Capacity
  3,                         !- Maximum Cycling Rate {cycles/hr}
  45,                        !- Latent Capacity Time Constant {s}
  ,                          !- Condenser Air Inlet Node Name
  AirCooled,                 !- Condenser Type
  ,                          !- Evaporative Condenser Effectiveness
  ,                          !- Evaporative Condenser Air Flow Rate {m^3/s}
  ,                          !- Evaporative Condenser Pump Rated Power Consumption {W}
  <%= crankcase_cap %>,   !- Crankcase Heater Capacity {W}
  <%= crankcase_max_temp %>,  !- Maximum Outdoor Dry-Bulb Temperature for Crankcase Heater Operation {C}
  ,                        !- Supply Water Storage Tank Name
  <%= clear_water_storage_tank %>;                        !- Condensate Collection Water Storage Tank Name

Curve:Biquadratic,
  <%= zone_name %> Cool-Cap-fT,   !- Name
  0.942587793,             !- Coefficient1 Constant
  0.009543347,             !- Coefficient2 x
  0.000683770,             !- Coefficient3 x**2
  -0.011042676,            !- Coefficient4 y
  0.000005249,             !- Coefficient5 y**2
  -0.000009720,            !- Coefficient6 x*y
  12.77778,                !- Minimum Value of x
  23.88889,                !- Maximum Value of x
  18.0,                    !- Minimum Value of y
  46.11111,                !- Maximum Value of y
  ,                        !- Minimum Curve Output
  ,                        !- Maximum Curve Output
  Temperature,             !- Input Unit Type for X
  Temperature,             !- Input Unit Type for Y
  Dimensionless;           !- Output Unit Type

Curve:Biquadratic,
  <%= zone_name %> Cool-EIR-fT,   !- Name
  0.342414409,             !- Coefficient1 Constant
  0.034885008,             !- Coefficient2 x
  -0.000623700,            !- Coefficient3 x**2
  0.004977216,             !- Coefficient4 y
  0.000437951,             !- Coefficient5 y**2
  -0.000728028,            !- Coefficient6 x*y
  12.77778,                !- Minimum Value of x
  23.88889,                !- Maximum Value of x
  18.0,                    !- Minimum Value of y
  46.11111,                !- Maximum Value of y
  ,                        !- Minimum Curve Output
  ,                        !- Maximum Curve Output
  Temperature,             !- Input Unit Type for X
  Temperature,             !- Input Unit Type for Y
  Dimensionless;           !- Output Unit Type

Curve:Quadratic,
  <%= zone_name %> Cool-PLF-fPLR,   !- Name
  0.85,                    !- Coefficient1 Constant
  0.15,                    !- Coefficient2 x
  0.0,                     !- Coefficient3 x**2
  0.0,                     !- Minimum Value of x
  1.0;                     !- Maximum Value of x

Curve:Quadratic,
  <%= zone_name %> Cool-Cap-fFF,  !- Name
  0.8,                     !- Coefficient1 Constant
  0.2,                     !- Coefficient2 x
  0.0,                     !- Coefficient3 x**2
  0.5,                     !- Minimum Value of x
  1.5;                     !- Maximum Value of x

Curve:Quadratic,
  <%= zone_name %> Cool-EIR-fFF,  !- Name
  1.1552,                  !- Coefficient1 Constant
  -0.1808,                 !- Coefficient2 x
  0.0256,                  !- Coefficient3 x**2
  0.5,                     !- Minimum Value of x
  1.5;                     !- Maximum Value of x

Coil:Heating:DX:SingleSpeed,
  <%= zone_name %> Heating Coil,  !- Name
  <%= zone_name %> Operation Schedule,  !- Availability Schedule Name
  Autosize,                       !- Rated Total Heating Capacity {W}
  <%= heating_coil_cop %>,        !- Rated COP
  Autosize,                         !- Rated Air Flow Rate {m^3/s}
  ,                               !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m/s)}
  <%= zone_name %> Cooling Coil Outlet Node, !- Air Inlet Node Name
  <%= zone_name %> Heating Coil Outlet Node,  !- Air Outlet Node Name
  <%= zone_name %> HP_Heat-Cap-fT,  !- Total Heating Capacity Function of Temperature Curve Name
  <%= zone_name %> HP_Heat-Cap-fFF,  !- Total Heating Capacity Function of Flow Fraction Curve Name
  <%= zone_name %> HP_Heat-EIR-fT,  !- Energy Input Ratio Function of Temperature Curve Name
  <%= zone_name %> HP_Heat-EIR-fFF,  !- Energy Input Ratio Function of Flow Fraction Curve Name
  <%= zone_name %> HP_Heat-PLF-fPLR,  !- Part Load Fraction Correlation Curve Name
  <%= zone_name %> DefrostEIR,  !- Defrost Energy Input Ratio Function of Temperature Curve Name
  <%= hp_min_temp %>,             !- Minimum Outdoor Dry-Bulb Temperature for Compressor Operation {C}
  ,                               !- Outdoor Dry-Bulb Temperature to Turn On Compressor {C}
  <%= hp_defrost_temp %>,         !- Maximum Outdoor Dry-Bulb Temperature for Defrost Operation {C}
  <%= crankcase_cap %>,           !- Crankcase Heater Capacity {W}
  <%= crankcase_max_temp %>,      !- Maximum Outdoor Dry-Bulb Temperature for Crankcase Heater Operation {C}
  ReverseCycle,                   !- Defrost Strategy
  Timed,                          !- Defrost Control
  0.166667;                       !- Defrost Time Period Fraction

Curve:Cubic,
  <%= zone_name %> HP_Heat-Cap-fT,   !- Name
  0.758746,                !- Coefficient1 Constant
  0.027626,                !- Coefficient2 x
  0.000148716,             !- Coefficient3 x**2
  0.0000034992,            !- Coefficient4 x**3
  -20.0,                   !- Minimum Value of x
  20.0,                    !- Maximum Value of x
  ,                        !- Minimum Curve Output
  ,                        !- Maximum Curve Output
  Temperature,             !- Input Unit Type for X
  Dimensionless;           !- Output Unit Type

Curve:Cubic,
  <%= zone_name %> HP_Heat-EIR-fT,   !- Name
  1.19248,                 !- Coefficient1 Constant
  -0.0300438,              !- Coefficient2 x
  0.00103745,              !- Coefficient3 x**2
  -0.000023328,            !- Coefficient4 x**3
  -20.0,                   !- Minimum Value of x
  20.0,                    !- Maximum Value of x
  ,                        !- Minimum Curve Output
  ,                        !- Maximum Curve Output
  Temperature,             !- Input Unit Type for X
  Dimensionless;           !- Output Unit Type

Curve:Quadratic,
  <%= zone_name %> HP_Heat-PLF-fPLR,   !- Name
  0.75,                    !- Coefficient1 Constant
  0.25,                    !- Coefficient2 x
  0.0,                     !- Coefficient3 x**2
  0.0,                     !- Minimum Value of x
  1.0;                     !- Maximum Value of x

Curve:Cubic,
  <%= zone_name %> HP_Heat-Cap-fFF,                        !- Name
  0.84,                    !- Coefficient1 Constant
  0.16,                    !- Coefficient2 x
  0.0,                     !- Coefficient3 x**2
  0.0,                     !- Coefficient4 x**3
  0.5,                     !- Minimum Value of x
  1.5;                     !- Maximum Value of x

Curve:Quadratic,
  <%= zone_name %> HP_Heat-EIR-fFF,                        !- Name
  1.3824,                  !- Coefficient1 Constant
  -0.4336,                 !- Coefficient2 x
  0.0512,                  !- Coefficient3 x**2
  0.0,                     !- Minimum Value of x
  1.0;                     !- Maximum Value of x

Curve:Biquadratic,
  <%= zone_name %> DefrostEIR,         !- Name
  0.1528,0,0,0,0,0,   !- Coefficients (List)
  -100,               !- Minimum Value of x
  100,                !- Maximum Value of x
  -100,               !- Minimum Value of y
  100;                !- Maximum Value of y

Fan:OnOff,
  <%= zone_name %> Heat Pump Fan,  !- Name
  <%= zone_name %> Operation Schedule,  !- Availability Schedule Name
  <%= fan_eff_supply %>,     !- Fan Efficiency
  <%= fan_rise_supply %>,    !- Pressure Rise {Pa}
  Autosize,    !- Maximum Flow Rate {m^3/s}
  0.85,                      !- Motor Efficiency
  1.0,                       !- Motor In Airstream Fraction
  <%= zone_name %> Heating Coil Outlet Node,  !- Air Inlet Node Name
  <%= zone_name %> Supply Fan Outlet Node;   !- Air Outlet Node Name

Coil:Heating:Electric,
  <%= zone_name %> Supp Heating Coil,  !- Name
  <%= zone_name %> Operation Schedule,  !- Availability Schedule Name
  1,                              !- Efficiency
  Autosize,                   !- Nominal Capacity
  <%= zone_name %> Supply Fan Outlet Node,  !- Air Inlet Node Name
  <%= zone_name %> Air Outlet Node;  !- Air Outlet Node Name

<% if (exhaust_fan) %>
<%# NOTE: Fan:ZoneExhaust appears to be forced on with night cycling which in turn forces on outdoor air.
Does not seem possible to do night cycle with exhaust fans without also getting outdoor air during unoccupied hours. %>
Fan:ZoneExhaust,
  <%= zone_name %> Exhaust Fan,  !- Name
  <%= zone_name %> Operation Schedule,  !- Availability Schedule Name
  <%= exhaust_fan_eff %>,  !- Fan Efficiency
  <%= exhaust_fan_rise %>,  !- Pressure Rise {Pa}
  <%= exhaust_fan_flow %>,  !- Maximum Flow Rate {m3/s}
  <%= zone_name %> Exhaust Fan Inlet Node,  !- Air Inlet Node Name
  <%= zone_name %> Exhaust Fan Outlet Node,  !- Air Outlet Node Name
  Zone Exhaust Fans;       !- End-Use Subcategory
<% end %>

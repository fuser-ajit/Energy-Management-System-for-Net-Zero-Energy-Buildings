<%#INITIALIZE
parameter "zone_name"

parameter "heating_setpoint", :default=>70|'F'
parameter "cooling_setpoint", :default=>75|'F'

parameter "heating_setpoint_sch", :default=>nil
parameter "cooling_setpoint_sch", :default=>nil

parameter "operation_schedule", :default=>
"
  Through: 12/31,          !- Field 1
  For: AllDays,            !- Field 2
  Until: 24:00, 1.0;       !- Field 3
"

%>

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
  <%= zone_name %>,  !- Zone Name
  <%= zone_name %> Equipment,  !- Zone Conditioning Equipment List Name
  <%= zone_name %> Inlet Node,  !- Zone Air Inlet Node or NodeList Name
  ,                        !- Zone Air Exhaust Node or NodeList Name
  <%= zone_name %> Air Node,  !- Zone Air Node Name
  <%= zone_name %> Return Node;  !- Zone Return Air Node Name

ZoneHVAC:EquipmentList,
  <%= zone_name %> Equipment,      !- Name
  SequentialLoad,  !- Load Distribution Scheme
  ZoneHVAC:IdealLoadsAirSystem,  !- Zone Equipment 1 Object Type
  <%= zone_name %> Ideal Loads,    !- Zone Equipment 1 Name
  1,                       !- Zone Equipment 1 Cooling Priority
  1,                       !- Zone Equipment 1 Heating or No-Load Sequence
  ,                        !- Zone Equipment 1 Sequential Cooling Fraction
  ;                        !- Zone Equipment 1 Sequential Heating Fraction

ZoneHVAC:IdealLoadsAirSystem,
  <%= zone_name %> Ideal Loads,  !- Name
  <%= zone_name %> Operation Schedule,  !- Availability Schedule Name
  <%= zone_name %> Inlet Node,  !- Zone Supply Air Node Name
  ,                        !- Zone Exhaust Air Node Name
  ,                        !- System Inlet Air Node Name
  50,                      !- Maximum Heating Supply Air Temperature {C}
  12.78,                   !- Minimum Cooling Supply Air Temperature {C}
  0.010,                   !- Maximum Heating Supply Air Humidity Ratio {kg-H2O/kg-air}
  0.008,                   !- Minimum Cooling Supply Air Humidity Ratio {kg-H2O/kg-air}
  NoLimit,                 !- Heating Limit
  ,                        !- Maximum Heating Air Flow Rate {m3/s}
  ,                        !- Maximum Sensible Heating Capacity {W}
  NoLimit;                 !- Cooling Limit

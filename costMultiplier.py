#!/usr/bin/env python

# $Date: 2020-10-24 10:31:56 -0600 (Fri, 21 May 2020) $
# $Rev: 6210 $



from __future__ import division
import sys
import outputDS
import sim as simpy
import units
import math
import os
from util import Constants

# Append Include so that we can import lxml
sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)),"Include"))
from lxml import etree #@UnresolvedImport

'''
Maps a cost multiplier to each economic property type, for use in economic
calculations.

Note: Fixed costs (with units of "$") should always have a cost multiplier of 1.
This accommodates the concept of removal costs (e.g. SEER 13 AC -> None), as
defined by the NREMDB. (The None option will not have a cost itself, so there
is no harm in having a non-zero cost multiplier.)
'''

class calculateMultipliers(outputDS.costs):

    def __init__(self, bldgdesc_xml, sim):
        super(calculateMultipliers, self).__init__()
        
        geometry = sim.getGeometry()
        self.num_units = geometry.num_units

        # Since sim.pool_heater, etc. are not available, use arbitrary unit for some of these calculations
        unit = geometry.units.unit[0]

        self.process_building()
        self.process_general_operation()
        self.process_major_appliances_operation()
        self.process_miscellaneous_operation()
        self.process_walls(geometry)
        self.process_roofs_ceilings(geometry)
        self.process_foundation_floors(geometry, sim.mat, sim.slab, sim.finished_basement, 
                                       sim.unfinished_basement, sim.crawlspace)
        self.process_thermal_mass(geometry.units.unit, geometry, sim.carpet)
        self.process_windows_and_shading(geometry, sim.overhangs, sim.facades, sim.door_area)
        self.process_airflow(geometry, unit.infiltration.InfiltrationLivingSpaceACH50)
        self.process_major_appliances()
        self.process_miscellaneous(unit.pool_heater, unit.pool_pump, unit.hot_tub_heater,
                                   unit.hot_tub_pump, unit.well_pump, unit.gas_fireplace,
                                   unit.gas_grill, unit.extra_refrigerator, unit.freezer, unit.gas_lighting)
        self.process_lighting(geometry)
        self.process_space_conditioning(geometry.units.unit, unit.ceiling_fans, sim.ducts_total_duct_surface_area,
                                        sim.hasHeatingEquipment, sim.hasCoolingEquipment,
                                        sim.hasAirConditioner, sim.hasRoomAirConditioner, sim.hasFurnace, sim.hasBoiler,
                                        sim.hasHeatPump, sim.hasMiniSplitHP, sim.hasGroundSourceHP, 
                                        unit.dehumidifier, sim.hasDXDehumidifier, sim.hasForcedAirEquipment, sim.hasElecBaseboard,
                                        sim.hasWholeHouseFan, unit.furnace)
        self.process_water_heating(geometry.units.unit, sim.water_heater_volume_total_all_units, unit.water_distribution, 
                                   sim.hasSolarDHW, sim.central_water_heater, sim.central_distribution, sim.hasCentralWaterHeating,
                                   sim.hasUnitWaterHeating, sim.hasCentralDistribution)
        self.process_power_generation(sim.pv_system, sim.hasPVSystem)
        
    def process_building(self):
        # Orientation
        self.add_cost_multiplier(237, "$", 1)
        
        # Neighbors
        self.add_cost_multiplier(239, "$", 1)

    def process_general_operation(self):
        multiplier = self.num_units
        
        # Heating Set Point
        self.add_cost_multiplier(240, "$", multiplier)
        
        # Cooling Set Point
        self.add_cost_multiplier(242, "$", multiplier)
        
        # Humidity Set Point
        self.add_cost_multiplier(243, "$", multiplier)
        
        # Misc Electric Loads
        self.add_cost_multiplier(252, "$", multiplier)
        
        # Misc Hot Water Loads
        self.add_cost_multiplier(402, "$", multiplier)
        
        # Natural Ventilation
        self.add_cost_multiplier(246, "$", multiplier)

    def process_major_appliances_operation(self):
        multiplier = self.num_units
        
        # Refrigerator Schedule
        self.add_cost_multiplier(432, "$", multiplier)
        
        # Cooking Range Schedule
        self.add_cost_multiplier(433, "$", multiplier)
        
        # Clothes Dryer Schedule
        self.add_cost_multiplier(436, "$", multiplier)
        
    def process_miscellaneous_operation(self):
        multiplier = self.num_units
        
        # Extra Refrigerator Schedule
        self.add_cost_multiplier(437, "$", multiplier)
        
        # Freezer Schedule
        self.add_cost_multiplier(438, "$", multiplier)
        
        # Pool Heater Schedule
        self.add_cost_multiplier(439, "$", multiplier)
        
        # Pool Pump Schedule
        self.add_cost_multiplier(440, "$", multiplier)
        
        # Hot Tub/Spa Heater Schedule
        self.add_cost_multiplier(441, "$", multiplier)
        
        # Hot Tub/Spa Pump Schedule
        self.add_cost_multiplier(442, "$", multiplier)
        
        # Well Pump Schedule
        self.add_cost_multiplier(443, "$", multiplier)
        
        # Gas Fireplace Schedule
        self.add_cost_multiplier(444, "$", multiplier)
        
        # Gas Grill Schedule
        self.add_cost_multiplier(445, "$", multiplier)
        
        # Gas Lighting Schedule
        self.add_cost_multiplier(446, "$", multiplier)
        
        # Other Electric Loads Schedule
        self.add_cost_multiplier(447, "$", multiplier)

    def process_walls(self, geometry):
        # Wood Stud
        self.add_cost_multiplier(184, "$/ft^2 Exterior Wall", geometry.walls.wall_ext_area)
            
        # Double Wood Stud
        self.add_cost_multiplier(200, "$/ft^2 Exterior Wall", geometry.walls.wall_ext_area)
    
        # Steel Stud
        self.add_cost_multiplier(453, "$/ft^2 Exterior Wall", geometry.walls.wall_ext_area)
            
        # CMU
        self.add_cost_multiplier(176, "$/ft^2 Exterior Wall", geometry.walls.wall_ext_area)
            
        # SIP
        self.add_cost_multiplier(202, "$/ft^2 Exterior Wall", geometry.walls.wall_ext_area)
            
        # ICF
        self.add_cost_multiplier(203, "$/ft^2 Exterior Wall", geometry.walls.wall_ext_area)
            
        # Other
        self.add_cost_multiplier(249, "$/ft^2 Exterior Wall", geometry.walls.wall_ext_area)
            
        # Wall Sheathing
        self.add_cost_multiplier(410, "$/ft^2 Exterior Wall", geometry.walls.wall_ext_area)
            
        # Exterior Finish
        self.add_cost_multiplier(216, "$/ft^2 Exterior Wall", geometry.walls.wall_ext_finished_area)
        
        # Interzonal Walls
        self.add_cost_multiplier(394, "$/ft^2 Wall", geometry.walls.int_bdry_wall_area)

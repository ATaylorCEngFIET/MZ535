
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2023.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# axi_protocol, uart, pwm_func, pwm_func, pwm_func, pwm_func, pwm_func, pwm_func, pwm_func, pwm_func

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7s6ftgb196-1
   set_property BOARD_PART adiuvoengineering.com:leonidas:part0:1.1 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:ila:6.2\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
axi_protocol\
uart\
pwm_func\
pwm_func\
pwm_func\
pwm_func\
pwm_func\
pwm_func\
pwm_func\
pwm_func\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set sys_clock [ create_bd_port -dir I -type clk -freq_hz 100000000 sys_clock ]
  set_property -dict [ list \
   CONFIG.PHASE {0.0} \
 ] $sys_clock
  set pwm_op_0 [ create_bd_port -dir O pwm_op_0 ]
  set pwm_op_1 [ create_bd_port -dir O pwm_op_1 ]
  set pwm_op_2 [ create_bd_port -dir O pwm_op_2 ]
  set pwm_op_3 [ create_bd_port -dir O pwm_op_3 ]
  set pwm_op_4 [ create_bd_port -dir O pwm_op_4 ]
  set pwm_op_5 [ create_bd_port -dir O pwm_op_5 ]
  set pwm_op_6 [ create_bd_port -dir O pwm_op_6 ]
  set pwm_op_7 [ create_bd_port -dir O pwm_op_7 ]
  set rx [ create_bd_port -dir I rx ]
  set tx [ create_bd_port -dir O tx ]
  set locked_0 [ create_bd_port -dir O locked_0 ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT1_JITTER {130.958} \
    CONFIG.CLKOUT1_PHASE_ERROR {98.575} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100} \
    CONFIG.CLK_IN1_BOARD_INTERFACE {sys_clock} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {10.000} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {10.000} \
    CONFIG.MMCM_DIVCLK_DIVIDE {1} \
    CONFIG.USE_BOARD_FLOW {true} \
    CONFIG.USE_RESET {false} \
  ] $clk_wiz_0


  # Create instance: axi_protocol_0, and set properties
  set block_name axi_protocol
  set block_cell_name axi_protocol_0
  if { [catch {set axi_protocol_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axi_protocol_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: uart_0, and set properties
  set block_name uart
  set block_cell_name uart_0
  if { [catch {set uart_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $uart_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: pwm_func_0, and set properties
  set block_name pwm_func
  set block_cell_name pwm_func_0
  if { [catch {set pwm_func_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $pwm_func_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: pwm_func_1, and set properties
  set block_name pwm_func
  set block_cell_name pwm_func_1
  if { [catch {set pwm_func_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $pwm_func_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: pwm_func_2, and set properties
  set block_name pwm_func
  set block_cell_name pwm_func_2
  if { [catch {set pwm_func_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $pwm_func_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: pwm_func_3, and set properties
  set block_name pwm_func
  set block_cell_name pwm_func_3
  if { [catch {set pwm_func_3 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $pwm_func_3 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: pwm_func_4, and set properties
  set block_name pwm_func
  set block_cell_name pwm_func_4
  if { [catch {set pwm_func_4 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $pwm_func_4 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: pwm_func_5, and set properties
  set block_name pwm_func
  set block_cell_name pwm_func_5
  if { [catch {set pwm_func_5 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $pwm_func_5 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: pwm_func_6, and set properties
  set block_name pwm_func
  set block_cell_name pwm_func_6
  if { [catch {set pwm_func_6 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $pwm_func_6 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: pwm_func_7, and set properties
  set block_name pwm_func
  set block_cell_name pwm_func_7
  if { [catch {set pwm_func_7 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $pwm_func_7 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property CONFIG.CONST_VAL {0} $xlconstant_0


  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create instance: ila_0, and set properties
  set ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_0 ]
  set_property CONFIG.C_SLOT_0_AXI_PROTOCOL {AXI4S} $ila_0


  # Create interface connections
  connect_bd_intf_net -intf_net axi_protocol_0_m_axis [get_bd_intf_pins uart_0/s_axis] [get_bd_intf_pins axi_protocol_0/m_axis]
  connect_bd_intf_net -intf_net uart_0_m_axis [get_bd_intf_pins uart_0/m_axis] [get_bd_intf_pins axi_protocol_0/s_axis]
connect_bd_intf_net -intf_net [get_bd_intf_nets uart_0_m_axis] [get_bd_intf_pins uart_0/m_axis] [get_bd_intf_pins ila_0/SLOT_0_AXIS]

  # Create port connections
  connect_bd_net -net axi_protocol_0_reg_0 [get_bd_pins axi_protocol_0/reg_0] [get_bd_pins pwm_func_0/pwm_reg]
  connect_bd_net -net axi_protocol_0_reg_1 [get_bd_pins axi_protocol_0/reg_1] [get_bd_pins pwm_func_1/pwm_reg]
  connect_bd_net -net axi_protocol_0_reg_2 [get_bd_pins axi_protocol_0/reg_2] [get_bd_pins pwm_func_2/pwm_reg]
  connect_bd_net -net axi_protocol_0_reg_3 [get_bd_pins axi_protocol_0/reg_3] [get_bd_pins pwm_func_3/pwm_reg]
  connect_bd_net -net axi_protocol_0_reg_4 [get_bd_pins axi_protocol_0/reg_4] [get_bd_pins pwm_func_4/pwm_reg]
  connect_bd_net -net axi_protocol_0_reg_5 [get_bd_pins axi_protocol_0/reg_5] [get_bd_pins pwm_func_5/pwm_reg]
  connect_bd_net -net axi_protocol_0_reg_6 [get_bd_pins axi_protocol_0/reg_6] [get_bd_pins pwm_func_6/pwm_reg]
  connect_bd_net -net axi_protocol_0_reg_7 [get_bd_pins axi_protocol_0/reg_7] [get_bd_pins pwm_func_7/pwm_reg]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins axi_protocol_0/clk] [get_bd_pins uart_0/clk] [get_bd_pins pwm_func_0/clk] [get_bd_pins pwm_func_1/clk] [get_bd_pins pwm_func_2/clk] [get_bd_pins pwm_func_3/clk] [get_bd_pins pwm_func_4/clk] [get_bd_pins pwm_func_5/clk] [get_bd_pins pwm_func_6/clk] [get_bd_pins pwm_func_7/clk] [get_bd_pins ila_0/clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_ports locked_0]
  connect_bd_net -net pwm_func_0_pwm_op [get_bd_pins pwm_func_0/pwm_op] [get_bd_ports pwm_op_0]
  connect_bd_net -net pwm_func_1_pwm_op [get_bd_pins pwm_func_1/pwm_op] [get_bd_ports pwm_op_1]
  connect_bd_net -net pwm_func_2_pwm_op [get_bd_pins pwm_func_2/pwm_op] [get_bd_ports pwm_op_2]
  connect_bd_net -net pwm_func_3_pwm_op [get_bd_pins pwm_func_3/pwm_op] [get_bd_ports pwm_op_3]
  connect_bd_net -net pwm_func_4_pwm_op [get_bd_pins pwm_func_4/pwm_op] [get_bd_ports pwm_op_4]
  connect_bd_net -net pwm_func_5_pwm_op [get_bd_pins pwm_func_5/pwm_op] [get_bd_ports pwm_op_5]
  connect_bd_net -net pwm_func_6_pwm_op [get_bd_pins pwm_func_6/pwm_op] [get_bd_ports pwm_op_6]
  connect_bd_net -net pwm_func_7_pwm_op [get_bd_pins pwm_func_7/pwm_op] [get_bd_ports pwm_op_7]
  connect_bd_net -net rx_0_1 [get_bd_ports rx] [get_bd_pins uart_0/rx]
  connect_bd_net -net sys_clock_1 [get_bd_ports sys_clock] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net uart_0_tx [get_bd_pins uart_0/tx] [get_bd_ports tx]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_0/dout] [get_bd_pins axi_protocol_0/eop_reset]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins xlconstant_1/dout] [get_bd_pins uart_0/reset] [get_bd_pins axi_protocol_0/reset] [get_bd_pins pwm_func_0/resetn] [get_bd_pins pwm_func_1/resetn] [get_bd_pins pwm_func_2/resetn] [get_bd_pins pwm_func_3/resetn] [get_bd_pins pwm_func_4/resetn] [get_bd_pins pwm_func_5/resetn] [get_bd_pins pwm_func_6/resetn] [get_bd_pins pwm_func_7/resetn]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""



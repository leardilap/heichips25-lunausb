###############################################################################
# Created by write_sdc
###############################################################################
current_design spad_env_f_bit
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 5.0000 [get_ports {clk}]
set_clock_transition 0.1500 [get_clocks {clk}]
set_clock_uncertainty 0.2500 clk
set_propagated_clock [get_clocks {clk}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {spad_hit_async}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {env_bit}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {env_valid}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.0060 [get_ports {env_bit}]
set_load -pin_load 0.0060 [get_ports {env_valid}]
set_driving_cell -lib_cell sg13g2_buf_4 -pin {X} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {clk}]
set_driving_cell -lib_cell sg13g2_buf_4 -pin {X} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {spad_hit_async}]
###############################################################################
# Design Rules
###############################################################################
set_max_fanout 10.0000 [current_design]

start_gui

# Create the project
set PROJ_NAME "vga"
set PROJ_LOC ./
set SRC_ROOT ../

create_project $PROJ_NAME $PROJ_LOC -part xc7z010clg400-1 -force
set_property board_part digilentinc.com:zybo-z7-10:part0:1.0 [current_project]
set_property target_language VHDL [current_project]
set_property simulator_language VHDL [current_project]

set src_files { vga_driver.vhd video_mem.vhd top_vga.vhd }
set test_files { vga_driver_tb.vhd video_mem_tb.vhd top_vga_tb.vhd all_tb.vhd }
# Add the files
foreach f $src_files {
    set fname [file join $SRC_ROOT src/ $f ]
    add_files -fileset sim_1 $fname
}

foreach f $test_files {
    set fname [file join $SRC_ROOT test/ $f ]
    add_files -fileset sim_1 $fname
}

# Set the top model
set_property top all_tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
launch_simulation
run all

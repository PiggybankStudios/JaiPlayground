
#import "Basic";
#import "Compiler";
#import "String";
#import "File";
#import "File_Utilities";

build :: ()
{
	print("Building...\n");
	
	app: Workspace = compiler_create_workspace("App Workspace");
	appOps: Build_Options = get_build_options(app);
	appOps.output_path = "build/";
	appOps.intermediate_path = "build/";
	appOps.output_executable_name = "app";
	appOps.backend = .X64;
	// appOps.backend = .LLVM;
	set_optimization(*appOps, .DEBUG);
	// set_optimization(*appOps, .OPTIMIZED);
	appOps.dead_code_elimination = .NONE;
	appOps.text_output_flags &= ~(.OUTPUT_TIMING_INFO);
	set_build_options(appOps, app);
	
	add_build_file("app/main.jai", app);
	
	set_build_options_dc(.{do_output=false, write_added_strings=false});
}

#run build();

#import "Basic";
#import "Compiler";
#import "String";
#import "File";
#import "File_Utilities";

DEBUG_BUILD   :: true;
BUILD_WINDOWS :: true;
BUILD_LINUX   :: false;
BUILD_OSX     :: false;

PROJECT_NAME :: "Jai Playground";
PROJECT_NAME_SAFE :: "JaiPlayground";

build :: ()
{
	print("Building...\n");
	
	for targetOS: enum_values_as_enum(Operating_System_Tag)
	{
		if ((targetOS == .WINDOWS && BUILD_WINDOWS) ||
			(targetOS == .LINUX && BUILD_LINUX) ||
			(targetOS == .MACOS && BUILD_OSX))
		{
			app : Workspace = compiler_create_workspace(sprint("App Workspace (%)", targetOS));
			
			appOps : Build_Options = get_build_options(app);
			{
				appOps.os_target = targetOS;
				if (targetOS == OS)
				{
					appOps.output_path = "_build";
					appOps.intermediate_path = "_build";
					appOps.output_type = .EXECUTABLE;
				}
				else
				{
					appOps.output_path = sprint("_build/%", targetOS);
					appOps.intermediate_path = sprint("_build/%", targetOS);
					appOps.output_type = .OBJECT_FILE; //TODO: It seems we can't actually link a binary executable for other platforms currently?
				}
				appOps.output_executable_name = PROJECT_NAME_SAFE;
				appOps.backend = ifx DEBUG_BUILD then .X64 else .LLVM;
				set_optimization(*appOps, ifx DEBUG_BUILD then .DEBUG else .OPTIMIZED);
				appOps.dead_code_elimination = .NONE;
				appOps.text_output_flags = 0;
				// appOps.text_output_flags |= .OUTPUT_LINK_LINE;
				// appOps.text_output_flags |= .OUTPUT_TIMING_INFO;
			}
			set_build_options(appOps, app);
			
			add_build_file("app/main.jai", app);
		}
	}
	
	set_build_options_dc(.{do_output=false, write_added_strings=false});
}

#run build();

#import "Basic";
#import "Compiler";
#import "String";
#import "File";
#import "File_Utilities";
#import "Process";

#import,file "build_config.jai";
#import,dir "core/core_base";

build :: ()
{
	writeline_i("Building...");
	
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
				importDirs : [..]string;
				array_add(*importDirs, "core/");
				for appOps.import_path { array_add(*importDirs, it); }
				appOps.import_path = importDirs;
			}
			set_build_options(appOps, app);
			
			if (RUN_APP && targetOS == OS) { compiler_begin_intercept(app); }
			
			add_build_file("app/main.jai", app);
			
			if (RUN_APP && targetOS == OS)
			{
				while (true)
				{
					message := compiler_wait_for_message();
					if (message.kind == .COMPLETE)
					{
						//TODO: For some reason if we don't do capture_and_return_output then the output of the program displayed BEFORE the output of our build script which is confusing
						exeName := sprint("%1%2", PROJECT_NAME_SAFE, ifx (targetOS == .WINDOWS) then ".exe" else "");
						exePath := sprint("_build/%", exeName);
						printline_r("Running %...", exeName);
						writeline_r("");
						result, output := run_command(exePath, capture_and_return_output=true);
						printline_r("%", output);
						if (result.type != .EXITED)
						{
							printline_e("% %", exeName, result.type);
						}
						else if (result.exit_code != 0)
						{
							printline_e("% Exited with Code %", exeName, result.exit_code);
						}
						else
						{
							writeline_i("Done!");
						}
						break;
					}
				}
				compiler_end_intercept(app);
			}
		}
	}
	
	set_build_options_dc(.{do_output=false, write_added_strings=false});
}

#run build();
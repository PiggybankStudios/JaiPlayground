
#import "Basic";
#import,file "../build_config.jai";
#import,dir "../core/core_base";
#import,dir "../core/core_struct";

main :: ()
{
	#if DEBUG_BUILD
	{
		writeline_w("Running in DEBUG mode!");
	}
	test : v2;
	test.X = 10;
	test.Y = #ifx DEBUG_BUILD then 3.14159 else 4.6;
	test2 := v2.{10.0, 11.0};
	equal := (test == test2);
	writeline_o(sprint("Hello from the app! % length=%", test, my_length(test)));
}

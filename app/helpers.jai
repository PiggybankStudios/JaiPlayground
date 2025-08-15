
#if OS == .WINDOWS
{
	#import "Windows";
}

print_stdout_and_debugger :: (message: string)
{
	print(message);
	#if (OS == .WINDOWS)
	{
		OutputDebugStringA(temp_c_string(message));
	}
}

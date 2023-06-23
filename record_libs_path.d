import std.file : writeFile = write;
import std.file;
import std.path;
import std.stdio;
import std.string;

int main(string[] args)
{
	if (args.length != 2)
	{
		writeln("Please don't call this script manually, translate.bat/translate.sh should take care of it.");
		return 1;
	}

	if (!exists("dub.sdl.orig"))
		copy("dub.sdl", "dub.sdl.orig");

	auto data = readText("dub.sdl");
	version (Windows)
		string extra = "lflags `/LIBPATH:" ~ args[1].dirName.buildPath("libs") ~ "` platform=\"windows\"\nlibs \"python3\"";
	else version (Posix)
		string extra = "lflags `-L" ~ args[1].dirName.buildPath("libs") ~ "` platform=\"posix\"\nlibs \"python3\"";
	else
		static assert(false);

	auto insert = data[0 .. data.indexOf("// BEGIN DYNAMIC") + "// BEGIN DYNAMIC".length]
		~ "\n" ~ extra ~ "\n"
		~ data[data.indexOf("// END DYNAMIC") .. $];

	if (data != insert)
	{
		if (!exists(args[1].dirName.buildPath("libs")))
			stderr.writeln("Could not find Python libs/ folder, linking will probably fail!");

		version (Windows)
			if (!exists(args[1].dirName.buildPath("libs", "python3.lib")))
				stderr.writeln("Could not find Python libs/python3.lib, linking might fail!");

		writeFile("dub.sdl", insert);
	}

	return 0;
}
import std.stdio;
import std.getopt;
import std.file;
import std.algorithm;

import docgen;

void main(string[] args)
{
	string docDirectory	   = "./docs/";
	string outputDirectory = "./out/";
	string docIndex		   = "./index.json";
	bool   replaceColors   = true;
	bool   forceRemove	   = false;
	debug
	{
		forceRemove = true;
	}
	string style = "material.css";

	auto   arg = args.getopt(
		std.getopt.config.passThrough,
		"df|docs", "Input directory of the DDoc documentation folder", &docDirectory,
		"of|out", "Output directory of the generated documentation", &outputDirectory,
		"index", "index.json file from -Xf switch", &docIndex,
		"replaceColors", "Automatically replace <font color> with <font class>", &replaceColors,
		"style|css", "Stylesheet file", &style,
		"forceRemove", "Removes output directory before generating", &forceRemove
		);

	if (arg.helpWanted)
	{
		defaultGetoptPrinter("Documentation generator for D based on ddoc files using material design.", arg.options);
		return;
	}

	if (docDirectory[$ - 1] != '/')
	{
		docDirectory ~= '/';
	}

	if (outputDirectory[$ - 1] != '/')
	{
		outputDirectory ~= '/';
	}

	if (forceRemove && exists(outputDirectory))
	{
		if (outputDirectory == "/" || outputDirectory == "./")
		{
			writeln("Cannot force remove root directory. Please use another directory.");
			return;
		}
		rmdirRecurse(outputDirectory);
	}

	if (!exists(docDirectory))
	{
		writeln("Input directory does not exist! (", docDirectory, ")");
		return;
	}

	if (!exists(outputDirectory))
	{
		mkdirRecurse(outputDirectory);
	}

	if (!exists(docIndex))
	{
		docIndex = docDirectory ~ docIndex;
	}

	if (!exists(docIndex))
	{
		writeln("Input json does not exist! (", docIndex, ")");
		return;
	}

	auto dir = DirEntry(outputDirectory);
	if (dir.size > 0)
	{
		writeln("Output directory is not empty! Use --forceRemove to automatically delete output directory before outputting.");
		return;
	}

	generateDocumentation(docDirectory, outputDirectory, docIndex, replaceColors, style);
}

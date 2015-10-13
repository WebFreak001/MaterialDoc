module docgen;

import std.stdio;
import std.array;
import std.string;
import std.file;
import std.json;

import painlessjson;

struct DocumentationEntry
{
	string name;
	string kind;
	string file;
}

void generateDocumentation(string docDirectory, string outputDirectory, string docIndex, bool replaceColors, string style)
{
	auto   entries = fromJSON!(DocumentationEntry[])(parseJSON(docIndex));

	string sidebar = "<ul class='sidebar'>";
	string file;
	string name;

	string[string] files;

	foreach (entry; entries)
	{
		if (entry.kind == "module")
		{
			file = entry.file[entry.file.lastIndexOf('\\') + 1 .. entry.file.lastIndexOf(".d")];
			name = entry.name;
			if(name.indexOf('.') != -1)
				name = name[name.lastIndexOf('.') + 1 .. $];

			if (!exists(docDirectory ~ file ~ ".html"))
			{
				writeln(file, ".html doesn't exist!");
				continue;
			}

			files[entry.name] = file;

			sidebar ~= format("<a href='%s.html'><li title='%s'>%s</li></a>", entry.name, name, name);
		}
		else
		{
			writeln("Unknown Entry Kind: ", entry.kind);
		}
	}

	sidebar ~= "</ul>";

	copy(style, outputDirectory ~ style);

	foreach (string name, string file; files)
	{
		string content = cast(string) std.file.read(docDirectory ~ file ~ ".html");
		content = content.replaceFirst("<html>", "<!DOCTYPE html>\n<html>");
		content = content.replaceFirst("</head>", "<link rel='stylesheet' href='" ~ style ~ "'/></head>");
		content = content.replaceFirst("<body>", "<body>" ~ sidebar ~ "<div class='doc_content'>");
		content = content.replaceLast("</body>", "</div></body>");
		if (replaceColors)
		{
			content = content.replace("<font color=", "<font class=");
		}
		std.file.write(outputDirectory ~ name ~ ".html", content);
	}

	writeln("Generated Docs");
}

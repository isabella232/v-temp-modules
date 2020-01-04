using System.Collections.Generic;
using System.IO;
using System.Linq;
using CppAst;

namespace Generator
{
	public class Config
	{
		public string SrcDir {get; set;}
		public string DstDir {get; set;}
		public string ModuleName {get; set;}
		public bool SingleVFileExport  {get; set;} = false;
		public bool CopyHeadersToDstDir  {get; set;} = false;

		/// <summary>
		/// if a function name contains any of the strings present here it will be excluded from
		/// code generation.
		/// </summary>
		public string[] ExcludeFunctionsThatContain {get; set;} = new string[] {};

		/// <summary>
		/// if a function name starts with any prefix present, it will be stripped before writing the
		/// V function.
		/// </summary>
		public string[] StripPrefixFromFunctionNames {get; set;} = new string[] {};

		/// <summary>
		/// if true, if there is a common prefix for all the enum values it will be stripped when
		/// generating the V items
		/// </summary>
		public bool StripEnumItemCommonPrefix {get; set;} = true;

		/// <summary>
		/// used when UseHeaderFolder is true to determine if a file should be placed in the module
		/// root folder. If the folder the file is in is BaseSourceFolder it will be placed in the
		/// root folder.
		/// </summary>
		public string BaseSourceFolder {get; set;}

		/// <summary>
		/// if true, the folder the header is in will be used for the generated V file
		/// </summary>
		public bool UseHeaderFolder {get; set;} = true;

		/// <summary>
		/// custom map of C types to V types. Most default C types will be handled automatically.
		/// </summary>
		public Dictionary<string, string> CTypeToVType {get; set;} = new Dictionary<string, string>();

		public string[] Files {get; set;}

		/// <summary>
		/// List of the defines.
		/// </summary>
		public string[] Defines {get; set;} = new string[] {};

		/// <summary>
		/// List of the include folders.
		/// </summary>
		public string[] IncludeFolders {get; set;} = new string[] {};

		/// <summary>
		/// List of the system include folders.
		/// </summary>
		public string[] SystemIncludeFolders {get; set;} = new string[] {};

		/// <summary>
		/// List of the additional arguments passed directly to the C++ Clang compiler.
		/// </summary>
		public string[] AdditionalArguments {get; set;} = new string[] {};

		/// <summary>
		/// Gets or sets a boolean indicating whether un-named enum/struct referenced by a typedef will be renamed directly to the typedef name. Default is <c>true</c>
		/// </summary>
		public bool AutoSquashTypedef {get; set;} = true;

		public bool ParseAsCpp {get; set;} = true;

		public bool ParseComments {get; set;} = true;

		/// <summary>
		/// System Clang target. Default is "windows"
		/// </summary>
		public string TargetSystem {get; set;} = "windows";

		public CppParserOptions ToParserOptions()
		{
			AddSystemIncludes();

			var opts = new CppParserOptions();
			opts.Defines.AddRange(Defines);
			opts.IncludeFolders.AddRange(ToAbsolutePaths(IncludeFolders));
			opts.SystemIncludeFolders.AddRange(SystemIncludeFolders);
			opts.AdditionalArguments.AddRange(AdditionalArguments);
			opts.AutoSquashTypedef = AutoSquashTypedef;
			opts.TargetSystem = TargetSystem;
			opts.ParseComments = ParseComments;

			return opts;
		}

		void AddSystemIncludes()
		{
			if (TargetSystem == "darwin")
			{
				SystemIncludeFolders = SystemIncludeFolders.Union(new string[] {
					"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include",
					"/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include",
					"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/11.0.0/include"
				}).Distinct().ToArray();
			}
		}

		public List<string> GetFiles() => ToAbsolutePaths(Files).ToList();

		string[] ToAbsolutePaths(string[] paths)
		{
			return paths.Select(p => Path.IsPathRooted(p) ? p : Path.Combine(SrcDir, p)).ToArray();
		}
	}

	public static class ConfigExt
	{
		public static bool IsFunctionExcluded(this Config config, string function)
		{
			return config.ExcludeFunctionsThatContain.Where(exclude => function.Contains(exclude)).Any();
		}

		public static string StripFunctionPrefix(this Config config, string function)
		{
			var prefixes = config.StripPrefixFromFunctionNames.Where(p => function.StartsWith(p));
			if (prefixes.Count() > 0)
			{
				var longestPrefix = prefixes.Aggregate("", (max, cur) => max.Length > cur.Length ? max : cur);
				return function.Replace(longestPrefix, "");
			}
			return function;
		}
	}
}
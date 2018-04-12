// import std.stdio;
// import pz.file, pz.config;

// string parseFile = "foo.txt";

// void main()
// {
//     //PzFile pzf = new PzFile(parseFile, "r+");
//     //writeln(pzf.findln("item1"));
//     //writeln(pzf.findln("another1"));
//     // pzf.pushval("ayylmao", "-1");
//     // pzf.pushval("another1", "6.9");
//     // pzf.pushval("another2", "6.9");
//     // pzf.pushval("another3", "6.9");
//     // pzf.pushval("another4", "6.9");
//     // pzf.pushval("another5", "7.9");
//     // pzf.writeContentBuffer();
//     // //testing reading values
//     // writeln(pzf.findln("another1"));
//     // writeln(pzf.findln("another5"));
//     // writeln(pzf.findln("ayylmao"));
//     PzConfig pz = new PzConfig("foo.txt", true, true);
//     writeln(pz.getValue!bool("another3"));
//     writeln(pz.getValue!int("another2"));
//     writeln(pz.getValue!float("another5"));
//     writeln(pz.getValue!string("another1"));
//     pz.writeConfig("test", 100);
//     pz.save();
// }
import pz.file, pz.config;
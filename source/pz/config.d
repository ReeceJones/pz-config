module pz.config;
import pz.file;
import std.conv;

class PzConfig
{
public:
    this(string filename, bool read, bool write)
    {
        string param;
        if (read && write)
            param = "r+";
        else if (read == true)
            param = "r";
        else if (write == true)
            param = "w";
        else
            throw new PzFileException("invalid file parameters");
        this.pf = new PzFile(filename, param);
    }
    auto getValue(T)(string name) 
                      if (__traits(isArithmetic, T))
    {
        auto v = this.pf.findln(name);
        if (v == null)
            return cast(T)null;
        return to!T(v);
    }
    T[] getValues(T)(string name)
                    if (__traits(isArithmetic, T))
    {
        import std.algorithm.iteration, std.array, std.string, std.stdio;

        auto v = this.pf.findln(name);
        if (v == null)
            return cast(T[])null;

        auto values = v.split(",");
        auto f = values.map!(a => to!T(a.strip)).array;
        return f;
    }

    auto getValue(T)(string name) 
                      if (T.stringof == string.stringof)
    {
        auto v = this.pf.findln(name);
        if (v == null)
            return null;
        return text!T(v);
    }
    auto getValue(T)(string name) 
                      if (T.stringof == wstring.stringof)
    {
        auto v = this.pf.findln(name);
        if (v == null)
            return null;
        return wtext!T(v);
    }
    auto getValue(T)(string name) 
                      if (T.stringof == dstring.stringof)
    {
        auto v = this.pf.findln(name);
        if (v == null)
            return null;
        return dtext!T(v);
    }

    T[] getValues(T)(string name)
                    if (T.stringof == string.stringof
                    || T.stringof == wstring.stringof
                    || T.stringof == dstring.stringof)
    {
        import std.algorithm.iteration, std.array, std.string, std.stdio;

        auto v = this.pf.findln(name);
        if (v == null)
            return cast(T[])null;

        auto values = v.split(",");
        return values.map!(a => text!T(a.strip)).array;
    }

    void writeConfig(T)(string name, T val)
    {
        this.pf.pushval(name, text!T(val));
    }
    void read()
    {
        this.pf.reload();
    }
    void save()
    {
        this.pf.writeContentBuffer();
    }
private:
    PzFile pf;
}
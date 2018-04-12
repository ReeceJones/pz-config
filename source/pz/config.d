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
                      if (T.stringof == uint.stringof     || T.stringof == int.stringof
                        || T.stringof == ulong.stringof   || T.stringof == long.stringof
                        || T.stringof == ushort.stringof  || T.stringof == short.stringof
                        || T.stringof == byte.stringof    || T.stringof == ubyte.stringof
                        || T.stringof == float.stringof   || T.stringof == double.stringof)
    {
        auto v = this.pf.findln(name);
        if (v == null)
            return cast(T)null;
        return to!T(v);
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
    auto getValue(T)(string name) 
                    if (T.stringof == bool.stringof)
    {
        auto v = this.pf.findln(name);
        if (v == null)
            return false;
        return parse!T(v);
    }
    void writeConfig(T)(string name, T val)
    {
        this.pf.pushval(name, text!T(val));
    }
    void save()
    {
        this.pf.writeContentBuffer();
    }
private:
    PzFile pf;
}
module pz.file;
import std.stdio;
import std.file: exists;
import std.string: indexOf, strip, stripRight;
import std.format;

class PzFile
{
public:
    this(string filename, const(char[]) p)
    {
        this.filename = filename;
        if (filename.exists == false)
            throw new PzFileException(filename ~ " does not exist");
        else
        {
            this.realFile = new File(filename, p);
        }
        this.args = p;
        reload();
    }
    string getFilename()
    {
        return this.filename;
    }
    string findln(string cmp)
    {
        string val;
        if ((val = *(cmp in this.contents)) !is null)
            return val;
        return null;
    }
    //read the file, and load the config contents
    void reload()
    {
        this.contents.clear();
        string ln;
        while ((ln = this.realFile.readln()) !is null)
        {
            auto loc = ln.indexOf(' ');
            //dont want to read comments
            if (loc >= 0 && ln.strip[0] != '#')
            {
                this.contents[ln[0..loc]] = strip(ln[loc+1..$]);
            }
        }
        this.realFile.rewind();
    }
    void pushval(const string base, const string val)
    {
        contents[base] = val;
    }
    void writeContentBuffer()
    {
        //ughh why is there no elegant way to do this?
        //first we need to read the contents of the file we are looking for
        this.realFile.rewind();
        string[] buf = [];
        //we need to write contents to file
        //in the process we need to maintain its current structure, and if comments
        //if a value is not in the file before writing it will be appended

        //map containing whether a specific name has been written to file or not
        //honestly the value in here doesn't matter...the only thing tested is membership
        bool[string] written;

        string ln;
        //keep reading the file until we reach the end (null string)
        while ((ln = this.realFile.readln()) !is null)
        {
            //check to see if the line is a comment
            if (ln.strip.length == 0)
            {
                //its just white space so add it to the buffer
                buf ~= ln.strip();
            }
            else if (ln.strip[0] == '#')
            {
                //push the line to the buffer and move to the next iteration
                //also have to sanitize the string
                buf ~= ln.stripRight();
            }
            else
            {
                //parse the value
                //the cfg name is given then its value and they are seperated by the first line
                string name, val;
                ln.formattedRead!"%s %s"(name, val);
                //check to see if the name is present in the contents
                if ((val = *(name in contents)) !is null)
                {
                    buf ~= (name ~ " " ~ val);
                    //we wrote the value so we need to indicate that
                    written[name] = true;
                }
            }
        }
        //after reading the file we need to append unwritten elements
        foreach (key, val; contents)
        {
            //if the key is not in the written map, append it
            if (key !in written)
            {
                buf ~= (key ~ " " ~ val);
            }
        }
        //write(buf, "\n");
        //close reading the file
        this.realFile.close();
        //open the file for writing
        this.realFile = new File(filename, "w");
        //write the data into the file
        foreach (s; buf)
            this.realFile.writeln(s);
        //close the writing
        this.realFile.close();
        //reopen in original mode
        this.realFile = new File(filename, this.args);
    }
private:
    string filename;
    File* realFile;
    string[string] contents;
    const(char[]) args;
}

class PzFileException : Exception
{
    this(string msg)
    {
        super(msg);
    }
}
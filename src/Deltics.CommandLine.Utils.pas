
  unit Deltics.CommandLine.Utils;

interface

  uses
    Deltics.StringLists,
    Deltics.Strings;

  type
    CommandLineUtils = class
      class function CommandLineToArgs(const aString: String): IStringList;
      class function IsSwitch(const aString: String): Boolean; overload;
      class function IsSwitch(const aString: String; var aSwitch: String; var aValue: String): Boolean; overload;
    end;


implementation

{ CommandLineUtils }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function CommandLineUtils.CommandLineToArgs(const aString: String): IStringList;
  {
    Breaks a string into white-space separated elements.  Values in
     double-quotes are treated as single elements.  Double quotes within
     such values must be double-double-quoted:

    e.g.

      3 args:   arg1 "arg 2" arg3
      2 args:   arg1 arg2prefix;"arg 2 value";arg2suffix
      2 args:   arg1 arg2prefix;"arg ""2"" value";arg2suffix
  }

    procedure AddArg(const aArg: String);
    begin
      result.Add(STR.Unquote(aArg));
    end;

  const
    WHITESPACE = [' ', #8];
  var
    i: Integer;
    arg: String;
    inQuote: Boolean;
  begin
    result := TStringList.CreateManaged;

    inQuote := FALSE;
    arg     := '';
    i       := 1;

    while (i <= Length(aString)) do
    begin
      if inQuote then
      begin
        arg := arg + aString[i];

        if (aString[i] = '"') then
        begin
          if ((i = Length(aString)) or (aString[i + 1] <> '"')) then
            inQuote := FALSE;

          if ((i < Length(aString)) and (aString[i + 1] = '"')) then
          begin
            arg := arg + '"';
            Inc(i);
          end;
        end;

        Inc(i);
      end
      else if (aString[i] = '"') then
      begin
        inQuote := TRUE;
        arg     := arg + '"';
        Inc(i);
      end
      else if (ANSIChar(aString[i]) in WHITESPACE) then
      begin
        if (arg <> '') then
        begin
          AddArg(arg);
          arg := '';
        end;

        while (i <= Length(aString)) and (ANSIChar(aString[i]) in WHITESPACE) do
          Inc(i);
      end
      else
      begin
        arg := arg + aString[i];
        Inc(i);
      end;
    end;

    if (arg <> '') then
      AddArg(arg);
  end;



  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function CommandLineUtils.IsSwitch(const aString: String): Boolean;
  {
    Determines whether or not the specified string identifies a valid
     command-line switch (i.e. begins with a '-' character).
  }
  begin
    result := (Length(aString) > 1) and (aString[1] = '-');
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function CommandLineUtils.IsSwitch(const aString: String;
                                           var   aSwitch: String;
                                           var   aValue: String): Boolean;
  {
    Determines whether or not the specified string identifies a valid
     command-line switch, separating the switch from an associated
     value where present.

    A switch value is everything occuring after the switch and either
     a : or = separator, enabling switch values to include these symbols
     if required, e.g.

    String              Switch   aValue

     -d=DEBUG             -d      DEBUG
     -i:ABC;DEF           -i      ABC;DEF
     -a:Windows=WinAPI    -a      Windows=WinAPI
     -p=c:\output         -p      c:\output
  }
  var
    eqPos: Integer;
    coPos: Integer;
    sep: Char;
  begin
    aSwitch := '';
    aValue  := '';
    result  := IsSwitch(aString);

    if NOT result then
      EXIT;

    // Locate any ':' and/or '=' symbols in the string
    eqPos := Pos('=', aString);
    coPos := Pos(':', aString);

    if (eqPos = 0) and (coPos = 0) then         // No ':' or '=' found - there is no value
      sep := #0
    else if (coPos = 0) and (eqPos <> 0) then   // No ':'. '=' separates switch from value
      sep := '='
    else if (eqPos = 0) and (coPos <> 0) then   // No '='. ':' separates switch from value
      sep := ':'
    else if (coPos < eqPos) then                // ':' before '='.  ':' separates switch from value
      sep := ':'
    else
      sep := '=';                               // '=' before ':'.  '=' separates switch from value

    // We identified a separator so split the string into the switch and value components
    if sep <> #0 then
      STR.Split(aString, sep, aSwitch, aValue)
    else
      aSwitch := aString;
  end;



end.

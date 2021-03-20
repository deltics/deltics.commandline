
{$i deltics.commandline.inc}

  unit Deltics.CommandLine.Options;


interface

  uses
    Deltics.InterfacedObjects,
    Deltics.StringLists,
    Deltics.CommandLine.Interfaces;


  type
    TCommandLineOption = class(TComInterfacedObject, ICommandLineOption)
    private
      fAlts: IStringList;
      fIsEnabled: Boolean;
      fName: String;
      fValues: IStringList;
    private
      constructor Create(const aName: String; const aValues: IStringList; const aEnabled: Boolean); overload;
    public
      constructor Create(const aName: String; const aValue: String); overload;
      constructor Create(const aName: String; const aValues: IStringList); overload;
    private
      function get_Alts: IStringList;
      function get_Name: String;
      function get_Value: String;
      function get_Values: IStringList;
    public
      function IsEnabled: Boolean; overload;
      function IsEnabled(var aValue: String): Boolean; overload;
      function IsEnabled(var aValues: StringArray): Boolean; overload;
      function ValueOrDefault(const aDefault: String): String; overload;
      function ValueOrDefault(const aDefaults: StringArray): IStringList; overload;
      function ValueOrDefault(const aDefaults: IStringList): IStringList; overload;
      property Name: String read get_Name;
      property Values: IStringList read get_Values;
    end;


    TCommandLineOptions = class(TInterfaceList, ICommandLineOptions,
                                                ICommandLineOptionsParser)
    private
      function get_Count: Integer;
      function get_Item(const aIndex: Integer): ICommandLineOption;
      function Contains(const aString: String; var aOption: ICommandLineOption): Boolean; overload;
      function Contains(const aOption: String; var aValue: String): Boolean; overload;
      function Contains(const aOption: String; var aValues: IStringList): Boolean; overload;
    private
      fCommandLine: TWeakInterfaceReference;
      procedure AddOption(const aOption: String; const aValues: IStringList);
      function get_CommandLine: ICommandLine;
    public
      constructor Create(const aCommandLine: ICommandLine);
      property CommandLine: ICommandLine read get_CommandLine;
    end;


implementation

  uses
    Deltics.Strings;




  function CommandLineArgsAsStringList: IStringList;
  var
    i: Integer;
  begin
    result := TStringList.CreateManaged;

    for i := 1 to Pred(ParamCount) do
      result.Add(ParamStr(i));
  end;




{ TCommandLineValueOption }

  constructor TCommandLineOption.Create(const aName: String;
                                        const aValues: IStringList;
                                        const aEnabled: Boolean);
  begin
    inherited Create;

    fName       := aName;
    fValues     := aValues;
    fIsEnabled  := aEnabled;
  end;


  constructor TCommandLineOption.Create(const aName, aValue: String);
  var
    values: IStringList;
  begin
    values := TStringList.CreateManaged;
    values.Add(aValue);

    Create(aName, values, FALSE);
  end;


  constructor TCommandLineOption.Create(const aName: String;
                                        const aValues: IStringList);
  begin
    Create(aName, aValues.Clone, FALSE);
  end;


  function TCommandLineOption.get_Alts: IStringList;
  begin
    result := fAlts;
  end;


  function TCommandLineOption.get_Name: String;
  begin
    result := fName;
  end;


  function TCommandLineOption.get_Value: String;
  begin
    if fValues.Count > 0 then
      result := fValues[0]
    else
      result := '';
  end;


  function TCommandLineOption.get_Values: IStringList;
  begin
    result := TStringList.CreateManaged;
    result.Add(fValues);
  end;


  function TCommandLineOption.IsEnabled: Boolean;
  begin
    result := fIsEnabled;
  end;


  function TCommandLineOption.IsEnabled(var aValue: String): Boolean;
  begin
    result := fIsEnabled;

    if result then
      aValue := get_Value;
  end;


  function TCommandLineOption.IsEnabled(var aValues: StringArray): Boolean;
  begin
    result := fIsEnabled;

    if result then
      aValues := fValues.AsArray;
  end;


  function TCommandLineOption.ValueOrDefault(const aDefault: String): String;
  begin
    if IsEnabled then
      result := get_Value
    else
      result := aDefault;
  end;


  function TCommandLineOption.ValueOrDefault(const aDefaults: StringArray): IStringList;
  begin
    if NOT IsEnabled then
    begin
      result := TStringList.CreateManaged;
      result.Add(aDefaults);
    end
    else
      result := get_Values;
  end;


  function TCommandLineOption.ValueOrDefault(const aDefaults: IStringList): IStringList;
  begin
    if NOT IsEnabled then
    begin
      result := TStringList.CreateManaged;
      result.Add(aDefaults);
    end
    else
      result := get_Values;
  end;




{ TCommandLineOptionList }

  constructor TCommandLineOptions.Create(const aCommandLine: ICommandLine);
  begin
    inherited Create;

    fCommandLine := TWeakInterfaceReference.Create(aCommandLine);
  end;


  procedure TCommandLineOptions.AddOption(const aOption: String; const aValues: IStringList);
  var
    switch: ICommandLineOption;
    values: IStringList;
  begin
    values := TStringList.CreateManaged;
    values.Add(aValues);

    switch := TCommandLineOption.Create(aOption, values, TRUE);

    inherited Add(switch);
  end;


  function TCommandLineOptions.Contains(const aString: String;
                                        var   aOption: ICommandLineOption): Boolean;
  var
    i, j: Integer;
    alts: IStringList;
    cmd: ICommandLine;
    opt: ICommandLineOption;
  begin
    result  := FALSE;
    aOption := NIL;

    // First check registered switches as these may have ALT options which
    //  may match even if the actual option on the command line is different

    for i := 0 to Pred(get_Count) do
    begin
      aOption := get_Item(i);
      result  := STR.SameText(aOption.get_Name, aString);
      if result then
        EXIT;

      alts := aOption.get_Alts;
      if NOT Assigned(alts) then
        CONTINUE;

      for j := 0 to Pred(alts.Count) do
      begin
        result  := STR.SameText(alts[j], aString);
        if result then
          EXIT;
      end;
    end;

    // OK, so now we need to scan all actual command line options

    cmd := CommandLine;
    for i := 0 to Pred(cmd.Options.Count) do
    begin
      opt := cmd.Options[i];

      result := STR.SameText(opt.Name, aString);
      if result then
      begin
        aOption := opt;
        EXIT;
      end;
    end;
  end;


  function TCommandLineOptions.Contains(const aOption: String;
                                        var   aValue: String): Boolean;
  var
    switch: ICommandLineOption;
  begin
    result := Contains(aOption, switch);
    if result then
      aValue := switch.Value;
  end;


  function TCommandLineOptions.Contains(const aOption: String;
                                        var   aValues: IStringList): Boolean;
  var
    switch: ICommandLineOption;
  begin
    result := Contains(aOption, switch);
    if result then
      aValues := switch.Values.Clone;
  end;


  function TCommandLineOptions.get_CommandLine: ICommandLine;
  begin
    result := fCommandLine as ICommandLine;
  end;


  function TCommandLineOptions.get_Count: Integer;
  begin
    result := inherited Count;
  end;


  function TCommandLineOptions.get_Item(const aIndex: Integer): ICommandLineOption;
  begin
    result := (inherited Items[aIndex]) as ICommandLineOption;
  end;







end.

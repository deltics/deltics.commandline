
  unit Deltics.CommandLine.Interfaces;

interface

  uses
    SysUtils,
    Deltics.StringLists,
    Deltics.Strings;


  type
    EInvalidCommandLine = class(Exception);



    ICommandLine = interface;
    ICommandLineOption = interface;
    ICommandLineOptions = interface;



    ICommandLine = interface
    ['{D0BEB917-2B40-43D9-9E7E-0CD10B1B6EE3}']
      function get_Arguments: IStringList;
      function get_AsString: String;
      function get_ExeFilename: String;
      function get_Params: IStringList;
      function get_Options: ICommandLineOptions;
      property Arguments: IStringList read get_Arguments;
      property AsString: String read get_AsString;
      property ExeFilename: String read get_ExeFilename;
      property Params: IStringList read get_Params;
      property Options: ICommandLineOptions read get_Options;
    end;


    ICommandLineOption = interface
    ['{4FCED93C-E1B0-4063-9D08-FBD0D9D16366}']
      function get_Name: String;
      function get_Alts: IStringList;
      function get_Value: String;
      function get_Values: IStringList;
      function IsEnabled: Boolean; overload;
      function IsEnabled(var aValue: String): Boolean; overload;
      function IsEnabled(var aValues: StringArray): Boolean; overload;
      function ValueOrDefault(const aDefault: String): String; overload;
      function ValueOrDefault(const aDefaults: StringArray): IStringList; overload;
      function ValueOrDefault(const aDefaults: IStringList): IStringList; overload;
      property Alts: IStringList read get_Alts;
      property Name: String read get_Name;
      property Value: String read get_Value;
      property Values: IStringList read get_Values;
    end;


    ICommandLineOptions = interface
    ['{CF183564-7D32-49A3-9A3D-C31DB9E4B378}']
      function get_Count: Integer;
      function get_Item(const aIndex: Integer): ICommandLineOption;
      function Contains(const aString: String; var aSwitch: ICommandLineOption): Boolean; overload;
      function Contains(const aName: String; var aValue: String): Boolean; overload;
      function Contains(const aName: String; var aValues: IStringList): Boolean; overload;
      property Count: Integer read get_Count;
      property Items[const aIndex: Integer]: ICommandLineOption read get_Item; default;
    end;


//    ICommandLineParser = interface
//    ['{5C416020-4C47-450C-96A5-991BF89D0C93}']
//      procedure Parse;
//    end;
//
//
//    IRegisteredCommandLineSwitchParser = interface
//    ['{97C1294D-7CEC-4C79-9D35-14734F846F85}']
//      procedure SetValue(const aValues: IStringList);
//    end;


    ICommandLineOptionsParser = interface
    ['{97C1294D-7CEC-4C79-9D35-14734F846F85}']
      procedure AddOption(const aName: String; const aValues: IStringList);
    end;



implementation

end.

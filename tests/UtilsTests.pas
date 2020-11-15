
unit UtilsTests;

interface

  uses
    Deltics.Smoketest;


  type
    TUtilsTests = class(TTest)
      procedure QuotesArePreservedOnQuotedArgs;
      procedure QuotesArePreservedOnInitialQuotedMultiValueArgumentPart;
      procedure QuotesArePreservedOnQuotedPartOfMultiValueArgument;
      procedure QuotesArePreservedOnFinalQuotedMultiValueArgumentPart;
      procedure OptionsAreParsedAsArguments;
    procedure EscapedQuotesInQuotedArgsResultInQuotes;
    procedure EscapedQuotesOnInitialQuotedMultiValueArgumentResultInQuotes;
    end;


implementation

  uses
    Deltics.Strings,
    Deltics.CommandLine.Utils;


{ TUtilsTests }

  procedure TUtilsTests.EscapedQuotesInQuotedArgsResultInQuotes;
  var
    args: IStringList;
  begin
    args := CommandLineUtils.CommandLineToArgs('cmd "arg ""1"""');

    Assert('There are two arguments', args.Count = 2);
    Assert('Argument[0] is "cmd"', args[0] = 'cmd');
    Assert('Argument[1] is ""arg ""1""""', args[1] = '"arg ""1"""', 'Argument[1] is "' + args[1] + '"');
  end;


  procedure TUtilsTests.EscapedQuotesOnInitialQuotedMultiValueArgumentResultInQuotes;
  var
    args: IStringList;
  begin
    args := CommandLineUtils.CommandLineToArgs('cmd """part"" 1";part2');

    Assert('There are two arguments', args.Count = 2);
    Assert('Argument[0] is "cmd"', args[0] = 'cmd');
    Assert('Argument[1] is """"part"" 1";part2"', args[1] = '"""part"" 1";part2', 'Argument[1] is "' + args[1] + '"');
  end;


  procedure TUtilsTests.QuotesArePreservedOnQuotedArgs;
  var
    args: IStringList;
  begin
    args := CommandLineUtils.CommandLineToArgs('cmd "arg 1"');

    Assert('There are two arguments', args.Count = 2);
    Assert('Argument[0] is "cmd"', args[0] = 'cmd');
    Assert('Argument[1] is "arg 1"', args[1] = '"arg 1"');
  end;


  procedure TUtilsTests.QuotesArePreservedOnQuotedPartOfMultiValueArgument;
  var
    args: IStringList;
  begin
    args := CommandLineUtils.CommandLineToArgs('cmd part1;"part 2";part3');

    Assert('There are two arguments', args.Count = 2);
    Assert('Argument[0] is "cmd"', args[0] = 'cmd');
    Assert('Argument[1] is "part1;"part 2";part3"', args[1] = 'part1;"part 2";part3', 'Argument[1] is "' + args[1] + '"');
  end;


  procedure TUtilsTests.QuotesArePreservedOnInitialQuotedMultiValueArgumentPart;
  var
    args: IStringList;
  begin
    args := CommandLineUtils.CommandLineToArgs('cmd "part 1";part2');

    Assert('There are two arguments', args.Count = 2);
    Assert('Argument[0] is "cmd"', args[0] = 'cmd');
    Assert('Argument[1] is ""part 1";part2"', args[1] = '"part 1";part2', 'Argument[1] is "' + args[1] + '"');
  end;


  procedure TUtilsTests.QuotesArePreservedOnFinalQuotedMultiValueArgumentPart;
  var
    args: IStringList;
  begin
    args := CommandLineUtils.CommandLineToArgs('cmd part1;part2;"part 3"');

    Assert('There are two arguments', args.Count = 2);
    Assert('Argument[0] is "cmd"', args[0] = 'cmd');
    Assert('Argument[1] is "part1;part2;"part 3""', args[1] = 'part1;part2;"part 3"', 'Argument[1] is "' + args[1] + '"');
  end;


  procedure TUtilsTests.OptionsAreParsedAsArguments;
  var
    args: IStringList;
  begin
    args := CommandLineUtils.CommandLineToArgs('cmd -opt1 param1');

    Assert('There are three arguments', args.Count = 3);
    Assert('Argument[0] is "cmd"', args[0] = 'cmd');
    Assert('Argument[1] is "-opt1"', args[1] = '-opt1', 'Argument[1] is "' + args[1] + '"');
    Assert('Argument[2] is "param1"', args[2] = 'param1', 'Argument[2] is "' + args[2] + '"');
  end;



end.

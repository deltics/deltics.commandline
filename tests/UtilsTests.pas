
unit UtilsTests;

interface

  uses
    Deltics.Smoketest;


  type
    TUtilsTests = class(TTest)
      procedure QuotesAreRemovedFromQuotedArgs;
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
    Deltics.StringLists,
    Deltics.CommandLine.Utils;


{ TUtilsTests }

  procedure TUtilsTests.EscapedQuotesInQuotedArgsResultInQuotes;
  var
    args: IStringList;
  begin
    args := CommandLineUtils.CommandLineToArgs('cmd "arg ""1"""');

    Test('args.Count').Assert(args.Count).Equals(2);
    Test('args[0]').Assert(args[0]).Equals('cmd');
    Test('args[1]').Assert(args[1]).Equals('arg "1"');
  end;


  procedure TUtilsTests.EscapedQuotesOnInitialQuotedMultiValueArgumentResultInQuotes;
  var
    args: IStringList;
  begin
    args := CommandLineUtils.CommandLineToArgs('cmd """part"" 1";part2');

    Test('args.Count').Assert(args.Count).Equals(2);
    Test('args[0]').Assert(args[0]).Equals('cmd');
    Test('args[1]').Assert(args[1]).Equals('"""part"" 1";part2');
  end;


  procedure TUtilsTests.QuotesAreRemovedFromQuotedArgs;
  var
    args: IStringList;
  begin
    args := CommandLineUtils.CommandLineToArgs('cmd "arg 1"');

    Test('args.Count').Assert(args.Count).Equals(2);
    Test('args[0]').Assert(args[0]).Equals('cmd');
    Test('args[1]').Assert(args[1]).Equals('arg 1');
  end;


  procedure TUtilsTests.QuotesArePreservedOnQuotedPartOfMultiValueArgument;
  var
    args: IStringList;
  begin
    args := CommandLineUtils.CommandLineToArgs('cmd part1;"part 2";part3');

    Test('args.Count').Assert(args.Count).Equals(2);
    Test('args[0]').Assert(args[0]).Equals('cmd');
    Test('args[1]').Assert(args[1]).Equals('part1;"part 2";part3');
  end;


  procedure TUtilsTests.QuotesArePreservedOnInitialQuotedMultiValueArgumentPart;
  var
    args: IStringList;
  begin
    args := CommandLineUtils.CommandLineToArgs('cmd "part 1";part2');

    Test('args.Count').Assert(args.Count).Equals(2);
    Test('args[0]').Assert(args[0]).Equals('cmd');
    Test('args[1]').Assert(args[1]).Equals('"part 1";part2');
  end;


  procedure TUtilsTests.QuotesArePreservedOnFinalQuotedMultiValueArgumentPart;
  var
    args: IStringList;
  begin
    args := CommandLineUtils.CommandLineToArgs('cmd part1;part2;"part 3"');

    Test('args.Count').Assert(args.Count).Equals(2);
    Test('args[0]').Assert(args[0]).Equals('cmd');
    Test('args[1]').Assert(args[1]).Equals('part1;part2;"part 3"');
  end;


  procedure TUtilsTests.OptionsAreParsedAsArguments;
  var
    args: IStringList;
  begin
    args := CommandLineUtils.CommandLineToArgs('cmd -opt1 param1');

    Test('args.Count').Assert(args.Count).Equals(3);
    Test('args[0]').Assert(args[0]).Equals('cmd');
    Test('args[1]').Assert(args[1]).Equals('-opt1');
    Test('args[2]').Assert(args[2]).Equals('param1');
  end;



end.

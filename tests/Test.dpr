

program Test;

uses
  Deltics.Smoketest,
  UtilsTests in 'UtilsTests.pas',
  Deltics.CommandLine.Interfaces in '..\src\Deltics.CommandLine.Interfaces.pas',
  Deltics.CommandLine.Options in '..\src\Deltics.CommandLine.Options.pas',
  Deltics.CommandLine in '..\src\Deltics.CommandLine.pas',
  Deltics.CommandLine.Utils in '..\src\Deltics.CommandLine.Utils.pas';

begin
  TestRun.Test(TUtilsTests);
end.

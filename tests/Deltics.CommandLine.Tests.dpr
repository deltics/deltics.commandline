program Deltics.CommandLine.Tests;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Deltics.Smoketest,
  Deltics.CommandLine in '..\src\Deltics.CommandLine.pas',
  Deltics.CommandLine.Interfaces in '..\src\Deltics.CommandLine.Interfaces.pas',
  Deltics.CommandLine.Options in '..\src\Deltics.CommandLine.Options.pas',
  Deltics.CommandLine.Utils in '..\src\Deltics.CommandLine.Utils.pas',
  UtilsTests in 'UtilsTests.pas';

begin
  TestRun.Test(TUtilsTests);
  ReadLn;
end.

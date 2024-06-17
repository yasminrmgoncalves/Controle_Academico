program AppControleAcademicoTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  TestuInscricao in 'TestuInscricao.pas',
  uInscricao in '..\uInscricao.pas',
  uPainelAdmin in '..\uPainelAdmin.pas' {frmPainelAdmin},
  uPainelAluno in '..\uPainelAluno.pas' {frmPainelAluno},
  uDataModule in '..\uDataModule.pas' {DataModule1: TDataModule};

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.


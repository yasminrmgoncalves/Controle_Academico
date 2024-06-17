program AppControleAcademico;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  uLogin in 'uLogin.pas' {frmLogin},
  uPainelAluno in 'uPainelAluno.pas' {frmPainelAluno},
  uInscricao in 'uInscricao.pas' {frmInscricao},
  uDataModule in 'uDataModule.pas' {DataModule1: TDataModule},
  uFuncoes in 'uFuncoes.pas',
  uPainelAdmin in 'uPainelAdmin.pas' {frmPainelAdmin};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmPainelAluno, frmPainelAluno);
  Application.CreateForm(TfrmInscricao, frmInscricao);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TfrmPainelAdmin, frmPainelAdmin);
  Application.Run;
end.

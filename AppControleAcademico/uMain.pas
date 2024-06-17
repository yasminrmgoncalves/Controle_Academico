unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Imaging.jpeg;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    edtUsuario: TEdit;
    edtSenha: TMaskEdit;
    btnEntrar: TButton;
    Image2: TImage;
    btnAdmin: TButton;
    procedure btnEntrarClick(Sender: TObject);
    procedure btnAdminClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uLogin, uPainelAluno, uDataModule, uPainelAdmin;

{$R *.dfm}

procedure TfrmMain.btnAdminClick(Sender: TObject);
begin
  DataModule1.sql_alunos_.Close;
  DataModule1.sql_alunos_.Open;
  frmPainelAdmin.ShowModal;
  Close;
end;

procedure TfrmMain.btnEntrarClick(Sender: TObject);
var
  i: Integer;
begin

  if edtUsuario.Text = '' then
  begin
    ShowMessage('Digite um nome de usu�rio.');
    exit
  end
  else if edtSenha.Text = '' then
  begin
    ShowMessage('Digite uma senha.');
    exit;
  end;

  DataModule1.sql_alunos_.Close;
  DataModule1.sql_alunos_.Open;

  for i := 0 to DataModule1.sql_alunos_.RecordCount-1 do
  begin
    if (edtUsuario.Text = DataModule1.sql_alunos_nome_aluno.AsString)
      and (edtSenha.Text = DataModule1.sql_alunos_senha_aluno.AsString) then
    begin
      frmPainelAluno.labelTit.Caption := 'Painel do Aluno - ' + edtusuario.Text;
      frmPainelAluno.ShowModal;
      Close;
    end;
    DataModule1.sql_alunos_.Next;
  end;

end;

end.

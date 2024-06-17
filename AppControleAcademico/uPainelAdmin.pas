unit uPainelAdmin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrmPainelAdmin = class(TForm)
    pnlPrincipal: TPanel;
    pnlTitulo: TPanel;
    labelTit: TLabel;
    img_icon: TImage;
    pnlBottom: TPanel;
    gdAlunos: TDBGrid;
    Label1: TLabel;
    procedure gdAlunosDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    var
      id_aluno : Integer;
      admin: Boolean;
  end;

var
  frmPainelAdmin: TfrmPainelAdmin;
implementation

uses
  uDataModule, uPainelAluno;

{$R *.dfm}

procedure TfrmPainelAdmin.gdAlunosDblClick(Sender: TObject);
begin
  id_aluno := DataModule1.sql_alunos_id_aluno.AsInteger;
  admin := True;
  frmPainelAluno.ShowModal;
end;

end.

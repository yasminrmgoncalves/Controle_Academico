unit uInscricao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Comp.Client;

type
  TfrmInscricao = class(TForm)
    pnlPrincipal: TPanel;
    pnlTitulo: TPanel;
    Label1: TLabel;
    img_incricao: TImage;
    Label2: TLabel;
    btnAdicionar: TPanel;
    cbDisciplinas: TComboBox;
    pnlInformacoesDisciplina: TPanel;
    Label3: TLabel;
    lbNomeDisciplina: TLabel;
    lbProfessorDisciplina: TLabel;
    lbDiaSemana: TLabel;
    lbSala: TLabel;
    lbHorario: TLabel;
    gdDisciplinas: TDBGrid;
    Label4: TLabel;
    btnFinalizarInscricao: TPanel;
    pnlListaEspera: TPanel;
    Label5: TLabel;
    btnNao: TPanel;
    btnListaEspera: TPanel;
    Panel1: TPanel;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    procedure cbDisciplinasChange(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnFinalizarInscricaoClick(Sender: TObject);
    procedure btnNaoClick(Sender: TObject);
    procedure btnListaEsperaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function VerificacoesRN: Boolean;
    function VerificaRN00(id_aluno, dia_semana : Integer; out disciplina, horario: String):Boolean;
    function VerificaRN01(id_aluno: Integer; out limite_credito: Integer):Boolean;
    function VerificaRN02(id_disciplina: Integer): Boolean;
    procedure CriaComponentesConexao;
    procedure PostDisciplinas;
    var
      disci_listaEsp : Integer;
      FConnection1: TFDConnection;  // Componente de conex�o local - Criado para mockar os dados j� existentes em banco
      sql : TFDQuery; // Componente de execu��o de queries para verifica��o das Regras de Neg�cio
  end;

var
  frmInscricao: TfrmInscricao;

implementation

uses
  uDataModule ,uPainelAdmin;

{$R *.dfm}

procedure TfrmInscricao.btnAdicionarClick(Sender: TObject);
begin
  if cbDisciplinas.Text <> '' then
  begin
    DataModule1.mDisciplinas_.Append;

    DataModule1.mDisciplinas_id_aluno.AsInteger := DataModule1.sql_alunos_id_aluno.AsInteger;
    DataModule1.mDisciplinas_id_disciplina.AsInteger := DataModule1.sql_disciplinas_id_disciplina.AsInteger;
    DataModule1.mDisciplinas_semestre.AsInteger := 1;
    DataModule1.mDisciplinas_ano.AsInteger := 2024;
    DataModule1.mDisciplinas_qtd_aula.AsInteger := DataModule1.sql_disciplinas_qtd_aula.AsInteger;
    DataModule1.mDisciplinas_dia_semana.AsInteger := DataModule1.sql_disciplinas_dia_semana.AsInteger;
    DataModule1.mDisciplinas_aprovado.AsBoolean := False;
    Datamodule1.mDisciplinas_.Post;
    DataModule1.mDisciplinas_.Refresh;
    DataModule1.mDisciplinas_.EnableControls;
    ShowMessage('Disciplina Adicionada');
  end;
end;

procedure TfrmInscricao.btnFinalizarInscricaoClick(Sender: TObject);
begin
  if VerificacoesRN then
  begin
    PostDisciplinas;
    ShowMessage('Inscri��es feitas com sucesso!');
    Close;
  end;

end;

procedure TfrmInscricao.btnListaEsperaClick(Sender: TObject);
begin
  DataModule1.sql_livre.Close;
  DataModule1.sql_livre.SQL.Clear;
  DataModule1.sql_livre.SQL.Text := 'select count(*) from tb_lista_espera where id_disciplina = :id_disciplina ';
  DataModule1.sql_livre.ParamByName('id_disciplina').AsInteger := disci_listaEsp;
  DataModule1.sql_livre.Open;

  DataModule1.sql_lista_espera_.Close;
  DataModule1.sql_lista_espera_.Open;
  DataModule1.sql_lista_espera_.Append;
  DataModule1.sql_lista_espera_id_aluno.AsInteger := DataModule1.sql_alunos_id_aluno.AsInteger;
  DataModule1.sql_lista_espera_id_disciplina.AsInteger := disci_listaEsp;
  DataModule1.sql_lista_espera_posicao_lista.AsInteger := DataModule1.sql_livre.Fields[0].Value + 1;
  DataModule1.sql_lista_espera_.Post;

  ShowMessage('Inser�ao na lista de espera realizada. Sua posi��o �: ' + IntToStr(DataModule1.sql_livre.Fields[0].Value + 1));
  pnlListaEspera.Visible := False;
  pnlListaEspera.Enabled := False;
end;

procedure TfrmInscricao.btnNaoClick(Sender: TObject);
begin
  pnlListaEspera.Visible := False;
  pnlListaEspera.Enabled := False;
end;

procedure TfrmInscricao.cbDisciplinasChange(Sender: TObject);
var
  dia: Integer;
begin
  DataModule1.sql_disciplinas_.Close;
  DataModule1.sql_disciplinas_.ParamByName('nome').AsString := cbDisciplinas.Text;
  DataModule1.sql_disciplinas_.Open;

  lbNomeDisciplina.Caption := DataModule1.sql_disciplinas_nome_disciplina.AsString;
  lbProfessorDisciplina.Caption := DataModule1.sql_disciplinas_professor_disciplina.AsString;
  lbSala.Caption :=  DataModule1.sql_disciplinas_sala.AsString;
  lbHorario.Caption :=  DataModule1.sql_disciplinas_horario.AsString;

  dia := DataModule1.sql_disciplinas_dia_semana.AsInteger;

  case dia of
    1:
      lbDiaSemana.Caption := 'Segunda-Feira';
    2:
      lbDiaSemana.Caption := 'Ter�a-Feira';
    3:
      lbDiaSemana.Caption := 'Quarta-Feira';
    4:
      lbDiaSemana.Caption := 'Quinta-Feira';
    5:
      lbDiaSemana.Caption := 'Sexta-Feira';
  end;

end;

procedure TfrmInscricao.CriaComponentesConexao;
begin
  // Cria a inst�ncia do projeto (constructor) e cria os componentes de banco
  FConnection1 := TFDConnection.Create(nil);
  FConnection1.DriverName := 'SQLite';
  FConnection1.Params.Database := ':memory:';
  FConnection1.LoginPrompt := False;

  FConnection1.Connected := True;
  sql := TFDQuery.Create(nil);
  sql.Connection := FConnection1;

  // Fazendo Mock dos dados presentes no banco

  //CRIANDO TABELA QUE RELACIONA ALUNO E DISCIPLINA
  FConnection1.ExecSQL('CREATE TABLE `tb_aluno_disciplina` ( '
                      +'  `id_aluno_disciplina` int(11) NOT NULL, '
                      +'  `id_aluno` int(11) NOT NULL, '
                      +'  `id_disciplina` int(11) NOT NULL, '
                      +'  `semestre` int(11) NOT NULL, '
                      +'  `ano` int(11) NOT NULL, '
                      +'  `qtd_aula` int(11) NOT NULL, '
                      +'  `dia_semana` int(11) NOT NULL, '
                      +'  `aprovado` tinyint(1) NOT NULL '
                      +')');
  //INSERINDO DADOS NA TABELA
  FConnection1.ExecSQL('INSERT INTO `tb_aluno_disciplina` (`id_aluno_disciplina`, `id_aluno`, `id_disciplina`, `semestre`, `ano`, `qtd_aula`, `dia_semana`, `aprovado`) VALUES '
                    +'(1, 1, 14, 2, 2022, 4, 1, 1), '
                    +'(2, 2, 9, 1, 2023, 4, 6, 1), '
                    +'(3, 18, 14, 2, 2022, 4, 1, 1), '
                    +'(32, 2, 14, 2, 2022, 4, 1, 1), '
                    +'(33, 3, 14, 2, 2022, 4, 1, 1), '
                    +'(34, 4, 14, 2, 2022, 4, 1, 1), '
                    +'(35, 5, 14, 2, 2022, 4, 1, 1), '
                    +'(36, 6, 14, 2, 2022, 4, 1, 1), '
                    +'(37, 7, 14, 2, 2022, 4, 1, 1), '
                    +'(38, 8, 14, 2, 2022, 4, 1, 1), '
                    +'(39, 9, 14, 2, 2022, 4, 1, 1), '
                    +'(40, 10, 14, 2, 2022, 4, 1, 1), '
                    +'(41, 11, 14, 2, 2022, 4, 1, 1), '
                    +'(42, 12, 14, 2, 2022, 4, 1, 1), '
                    +'(43, 14, 14, 2, 2022, 4, 1, 1), '
                    +'(44, 15, 14, 2, 2022, 4, 1, 1), '
                    +'(45, 16, 14, 2, 2022, 4, 1, 1), '
                    +'(46, 17, 14, 2, 2022, 4, 1, 1), '
                    +'(47, 18, 14, 2, 2022, 4, 1, 1), '
                    +'(48, 19, 14, 2, 2022, 4, 1, 1), '
                    +'(49, 20, 14, 2, 2022, 4, 1, 1), '
                    +'(50, 1, 11, 1, 2022, 4, 1, 1), '
                    +'(51, 2, 11, 1, 2022, 4, 1, 1), '
                    +'(52, 3, 11, 1, 2022, 4, 1, 1), '
                    +'(53, 4, 11, 1, 2022, 4, 1, 1), '
                    +'(54, 5, 11, 1, 2022, 4, 1, 1), '
                    +'(55, 6, 11, 1, 2022, 4, 1, 1), '
                    +'(56, 7, 11, 1, 2022, 4, 1, 1), '
                    +'(57, 8, 11, 1, 2022, 4, 1, 1), '
                    +'(58, 9, 11, 1, 2022, 4, 1, 1), '
                    +'(59, 10, 11, 1, 2022, 4, 1, 1), '
                    +'(60, 11, 11, 1, 2022, 4, 1, 1), '
                    +'(61, 12, 11, 1, 2022, 4, 1, 1), '
                    +'(62, 13, 11, 1, 2022, 4, 1, 1), '
                    +'(63, 14, 11, 1, 2022, 4, 1, 1), '
                    +'(64, 15, 11, 1, 2022, 4, 1, 1), '
                    +'(65, 16, 11, 1, 2022, 4, 1, 1), '
                    +'(66, 17, 11, 1, 2022, 4, 1, 1), '
                    +'(67, 18, 11, 1, 2022, 4, 1, 1), '
                    +'(68, 19, 11, 1, 2022, 4, 1, 1), '
                    +'(69, 20, 11, 1, 2022, 4, 1, 1), '
                    +'(70, 21, 11, 1, 2022, 4, 1, 1), '
                    +'(71, 22, 11, 1, 2022, 4, 1, 1), '
                    +'(72, 23, 11, 1, 2022, 4, 1, 1), '
                    +'(73, 24, 11, 1, 2022, 4, 1, 1), '
                    +'(74, 25, 11, 1, 2022, 4, 1, 1), '
                    +'(75, 26, 11, 1, 2022, 4, 1, 1), '
                    +'(76, 27, 11, 1, 2022, 4, 1, 1), '
                    +'(77, 28, 11, 1, 2022, 4, 1, 1), '
                    +'(78, 29, 11, 1, 2022, 4, 1, 1), '
                    +'(79, 30, 11, 1, 2022, 4, 1, 1), '
                    +'(80, 31, 11, 1, 2022, 4, 1, 1), '
                    +'(81, 32, 11, 1, 2022, 4, 1, 1), '
                    +'(82, 33, 11, 1, 2022, 4, 1, 1), '
                    +'(83, 34, 11, 1, 2022, 4, 1, 1), '
                    +'(84, 35, 11, 1, 2022, 4, 1, 1), '
                    +'(85, 36, 11, 1, 2022, 4, 1, 1), '
                    +'(86, 37, 11, 1, 2022, 4, 1, 1), '
                    +'(87, 38, 11, 1, 2022, 4, 1, 1), '
                    +'(88, 39, 11, 1, 2022, 4, 1, 1), '
                    +'(89, 40, 11, 1, 2022, 4, 1, 1), '
                    +'(90, 63, 1, 1, 2024, 4, 3, 1), '
                    +'(91, 62, 1, 1, 2024, 4, 3, 1), '
                    +'(92, 61, 1, 1, 2024, 4, 3, 1), '
                    +'(93, 60, 1, 1, 2024, 4, 3, 1), '
                    +'(94, 59, 1, 1, 2024, 4, 3, 1), '
                    +'(95, 58, 1, 1, 2024, 4, 3, 1), '
                    +'(96, 57, 1, 1, 2024, 4, 3, 1), '
                    +'(97, 56, 1, 1, 2024, 4, 3, 1), '
                    +'(98, 55, 1, 1, 2024, 4, 3, 1), '
                    +'(99, 10, 1, 1, 2024, 4, 3, 1), '
                    +'(100, 11, 1, 1, 2024, 4, 3, 1), '
                    +'(101, 12, 1, 1, 2024, 4, 3, 1), '
                    +'(102, 13, 1, 1, 2024, 4, 3, 1), '
                    +'(103, 14, 1, 1, 2024, 4, 3, 1), '
                    +'(104, 15, 1, 1, 2024, 4, 3, 1), '
                    +'(105, 16, 1, 1, 2024, 4, 3, 1), '
                    +'(106, 17, 1, 1, 2024, 4, 3, 1), '
                    +'(107, 18, 1, 1, 2024, 4, 3, 1), '
                    +'(108, 19, 1, 1, 2024, 4, 3, 1), '
                    +'(109, 63, 2, 1, 2024, 4, 5, 0), '
                    +'(110, 17, 2, 1, 2024, 4, 5, 1), '
                    +'(111, 63, 15, 1, 2024, 4, 1, 1), '
                    +'(112, 63, 17, 1, 2024, 2, 4, 1), '
                    +'(113, 17, 15, 1, 2024, 4, 1, 1), '
                    +'(114, 17, 17, 1, 2024, 2, 4, 1), '
                    +'(115, 63, 18, 1, 2024, 4, 2, 1), '
                    +'(116, 17, 18, 1, 2024, 4, 2, 1), '
                    +'(117, 62, 18, 1, 2024, 4, 2, 1), '
                    +'(118, 61, 18, 1, 2024, 4, 2, 1), '
                    +'(119, 60, 18, 1, 2024, 4, 2, 1), '
                    +'(120, 58, 18, 1, 2024, 4, 2, 1), '
                    +'(121, 57, 18, 1, 2024, 4, 2, 1), '
                    +'(122, 56, 18, 1, 2024, 4, 2, 1), '
                    +'(123, 55, 18, 1, 2024, 4, 2, 1), '
                    +'(124, 54, 18, 1, 2024, 4, 2, 1), '
                    +'(125, 53, 18, 1, 2024, 4, 2, 1), '
                    +'(126, 52, 18, 1, 2024, 4, 2, 1), '
                    +'(127, 51, 18, 1, 2024, 4, 2, 1), '
                    +'(128, 50, 18, 1, 2024, 4, 2, 1), '
                    +'(129, 49, 18, 1, 2024, 4, 2, 1), '
                    +'(130, 48, 18, 1, 2024, 4, 2, 1), '
                    +'(131, 47, 18, 1, 2024, 4, 2, 1), '
                    +'(132, 46, 18, 1, 2024, 4, 2, 1), '
                    +'(133, 45, 18, 1, 2024, 4, 2, 1), '
                    +'(134, 44, 18, 1, 2024, 4, 2, 1), '
                    +'(135, 43, 18, 1, 2024, 4, 2, 1), '
                    +'(136, 42, 18, 1, 2024, 4, 2, 1), '
                    +'(137, 41, 18, 1, 2024, 4, 2, 1), '
                    +'(138, 40, 18, 1, 2024, 4, 2, 1), '
                    +'(139, 39, 18, 1, 2024, 4, 2, 1), '
                    +'(140, 38, 18, 1, 2024, 4, 2, 1), '
                    +'(141, 37, 18, 1, 2024, 4, 2, 1), '
                    +'(142, 24, 18, 1, 2024, 4, 2, 1), '
                    +'(143, 23, 18, 1, 2024, 4, 2, 1), '
                    +'(144, 22, 18, 1, 2024, 4, 2, 1), '
                    +'(145, 21, 18, 1, 2024, 4, 2, 1), '
                    +'(146, 20, 18, 1, 2024, 4, 2, 1), '
                    +'(147, 19, 18, 1, 2024, 4, 2, 1), '
                    +'(148, 18, 18, 1, 2024, 4, 2, 1), '
                    +'(149, 16, 18, 1, 2024, 4, 2, 1), '
                    +'(150, 15, 18, 1, 2024, 4, 2, 1), '
                    +'(151, 14, 18, 1, 2024, 4, 2, 1), '
                    +'(152, 13, 18, 1, 2024, 4, 2, 1), '
                    +'(153, 12, 18, 1, 2024, 4, 2, 1), '
                    +'(154, 10, 18, 1, 2024, 4, 2, 1), '
                    +'(155, 61, 2, 1, 2024, 4, 5, 1), '
                    +'(156, 60, 2, 1, 2024, 4, 5, 1), '
                    +'(157, 58, 2, 1, 2024, 4, 5, 1), '
                    +'(158, 57, 2, 1, 2024, 4, 5, 1), '
                    +'(159, 56, 2, 1, 2024, 4, 5, 1), '
                    +'(160, 55, 2, 1, 2024, 4, 5, 1), '
                    +'(161, 54, 2, 1, 2024, 4, 5, 1), '
                    +'(162, 53, 2, 1, 2024, 4, 5, 1), '
                    +'(163, 52, 2, 1, 2024, 4, 5, 1), '
                    +'(164, 51, 2, 1, 2024, 4, 5, 1), '
                    +'(165, 50, 2, 1, 2024, 4, 5, 1), '
                    +'(166, 49, 2, 1, 2024, 4, 5, 1), '
                    +'(167, 48, 2, 1, 2024, 4, 5, 1), '
                    +'(168, 47, 2, 1, 2024, 4, 5, 1), '
                    +'(169, 46, 2, 1, 2024, 4, 5, 1), '
                    +'(170, 45, 2, 1, 2024, 4, 5, 1), '
                    +'(171, 44, 2, 1, 2024, 4, 5, 1), '
                    +'(172, 43, 2, 1, 2024, 4, 5, 1), '
                    +'(173, 42, 2, 1, 2024, 4, 5, 1), '
                    +'(174, 41, 2, 1, 2024, 4, 5, 1), '
                    +'(175, 40, 2, 1, 2024, 4, 5, 1), '
                    +'(176, 39, 2, 1, 2024, 4, 5, 1), '
                    +'(177, 38, 2, 1, 2024, 4, 5, 1), '
                    +'(178, 37, 2, 1, 2024, 4, 5, 1), '
                    +'(179, 24, 2, 1, 2024, 4, 5, 1), '
                    +'(180, 23, 2, 1, 2024, 4, 5, 1), '
                    +'(181, 22, 2, 1, 2024, 4, 5, 1), '
                    +'(182, 21, 2, 1, 2024, 4, 5, 1), '
                    +'(183, 20, 2, 1, 2024, 4, 5, 1), '
                    +'(184, 19, 2, 1, 2024, 4, 5, 1), '
                    +'(185, 18, 2, 1, 2024, 4, 5, 1), '
                    +'(186, 16, 2, 1, 2024, 4, 5, 1), '
                    +'(187, 10, 2, 1, 2024, 4, 5, 1), '
                    +'(188, 9, 2, 1, 2024, 4, 5, 1), '
                    +'(189, 8, 2, 1, 2024, 4, 5, 1), '
                    +'(190, 7, 2, 1, 2024, 4, 5, 1), '
                    +'(191, 6, 2, 1, 2024, 4, 5, 1), '
                    +'(192, 63, 16, 1, 2024, 2, 4, 0), '
                    +'(193, 1, 16, 1, 2024, 2, 4, 0), '
                    +'(194, 1, 16, 1, 2024, 2, 4, 0), '
                    +'(195, 2, 5, 1, 2024, 4, 5, 0), '
                    +'(196, 1, 14, 1, 2024, 4, 1, 0), '
                    +'(197, 4, 15, 1, 2024, 4, 1, 0), '
                    +'(198, 2, 15, 1, 2024, 4, 1, 0), '
                    +'(199, 4, 2, 1, 2024, 4, 5, 0), '
                    +'(200, 3, 14, 1, 2024, 4, 1, 0), '
                    +'(201, 17, 16, 1, 2024, 2, 4, 0), '
                    +'(204, 1, 12, 1, 2024, 4, 2, 0), '
                    +'(205, 1, 9, 1, 2024, 4, 5, 0), '
                    +'(206, 4, 16, 1, 2024, 2, 4, 0), '
                    +'(207, 4, 1, 1, 2024, 4, 3, 0), '
                    +'(208, 4, 17, 1, 2024, 2, 4, 0), '
                    +'(209, 2, 16, 1, 2024, 2, 4, 0), '
                    +'(210, 59, 5, 1, 2024, 4, 5, 0), '
                    +'(211, 59, 5, 1, 2024, 4, 5, 0), '
                    +'(212, 63, 16, 1, 2024, 2, 4, 0);');
//CRIANDO TABELA DISCIPLINA
    FConnection1.ExecSQL('CREATE TABLE `tb_disciplina` ( '
    +'  `id_disciplina` int(11) NOT NULL, '
    +'  `nome_disciplina` varchar(50) NOT NULL, '
    +'  `professor_disciplina` varchar(50) NOT NULL, '
    +'  `dia_semana` int(11) NOT NULL, '
    +'  `sala` varchar(10) NOT NULL, '
    +'  `horario` varchar(20) NOT NULL, '
    +'  `qtd_aula` int(11) NOT NULL '
    +')');
// INSERINDO DADOS NA TABELA DISCIPLINA
    FConnection1.ExecSQL('INSERT INTO `tb_disciplina` (`id_disciplina`, `nome_disciplina`, `professor_disciplina`, `dia_semana`, `sala`, `horario`, `qtd_aula`) VALUES '
    +'(1, ''Qualidade de Software'', ''Wilson Vendramel'', 3, ''A406'', ''19:00 - 22:35'', 4), '
    +'(2, ''Gest�o de Projetos'', ''Andr� Luis'', 5, ''A408'', ''19:00 - 22:35'', 4), '
    +'(5, ''Arquitetura de Software'', ''Cristina Correa'', 5, ''A501'', ''19:00 - 22:35'', 4), '
    +'(6, ''Estrutura de Dados 2'', ''Rafael Muniz'', 4, ''A406'', ''19:00 - 22:35'', 4), '
    +'(9, ''Estrutura de Dados 1'', ''Rafael Muniz'', 5, ''A402'', ''19:00 - 22:35'', 4), '
    +'(11, ''Linguagem de Programacao I'', ''Talita Cipriano'', 1, ''A501'', ''19:00 - 22:35'', 4), '
    +'(12, ''Linguagem de Programacao II'', ''Ana Paula'', 2, ''A402'', ''19:00 - 22:35'', 4), '
    +'(13, ''Linguagem de Programacao III'', ''Flavio Amate'', 4, ''A406'', ''19:00 - 22:35'', 4), '
    +'(14, ''Engenharia de Software'', ''Raphael Naves'', 1, ''A505'', ''19:00 - 22:35'', 4), '
    +'(15, ''Servicos de Rede '', ''Luciano'', 1, ''A409'', ''19:00 - 22:35'', 4), '
    +'(16, ''Metodologias Ageis'', ''Andre'', 4, ''A408'', ''19:00 - 20:40'', 2), '
    +'(17, ''Projetos de Sistemas I '', ''Flavio'', 4, ''A406'', ''20:40 - 22:35'', 2), '
    +'(18, ''Desenvolvimento Web'', ''Luis'', 2, ''A508'', ''19:00 - 22:35'', 4)');
end;

procedure TfrmInscricao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  cbDisciplinas.Items.Clear;
  DataModule1.mDisciplinas_.EmptyDataSet;
end;

procedure TfrmInscricao.Panel1Click(Sender: TObject);
begin
  DataModule1.mDisciplinas_.Delete;
end;

procedure TfrmInscricao.PostDisciplinas;
var
  i : Integer;
begin
  for i := 0 to DataModule1.mDisciplinas_.RecordCount -1 do
  begin
    DataModule1.sql_aluno_disciplina_.Close;
    DataModule1.sql_aluno_disciplina_.Open;
    DataModule1.sql_aluno_disciplina_.Insert;
    DataModule1.sql_aluno_disciplina_id_disciplina.AsInteger := DataModule1.mDisciplinas_id_disciplina.AsInteger;
    DataModule1.sql_aluno_disciplina_id_aluno.AsInteger := DataModule1.mDisciplinas_id_aluno.AsInteger;
    DataModule1.sql_aluno_disciplina_semestre.AsInteger := DataModule1.mDisciplinas_semestre.AsInteger;
    DataModule1.sql_aluno_disciplina_ano.AsInteger := DataModule1.mDisciplinas_ano.AsInteger;
    DataModule1.sql_aluno_disciplina_qtd_aula.AsInteger := DataModule1.mDisciplinas_qtd_aula.AsInteger;
    DataModule1.sql_aluno_disciplina_dia_semana.AsInteger := DataModule1.mDisciplinas_dia_semana.AsInteger;
    DataModule1.sql_aluno_disciplina_aprovado.AsBoolean := DataModule1.mDisciplinas_aprovado.AsBoolean;
    DataModule1.sql_aluno_disciplina_.Post;
    DataModule1.mDisciplinas_.Next;
  end;

end;

function TfrmInscricao.VerificacoesRN: Boolean;
var
  i, limite_credito, choque_horarios : Integer;
  disciplina, horario : String;
begin
// verifica��es das regras de neg�cio

  for i := 0 to DataModule1.mDisciplinas_.RecordCount -1  do
  begin
    //Traz informa��es da disciplina para mostrar nas mensagens
    DataModule1.sql_livre.Close;
    DataModule1.sql_livre.SQL.Clear;
    DataModule1.sql_livre.SQL.Text := 'select * from tb_disciplina where id_disciplina = :id_disciplina ';
    DataModule1.sql_livre.ParamByName('id_disciplina').AsInteger := DataModule1.mDisciplinas_id_disciplina.AsInteger;
    DataModule1.sql_livre.Open;

     //Chama fun��o de verifica��o da RN01:
    if VerificaRN01(DataModule1.mDisciplinas_id_aluno.AsInteger,limite_credito) then
      ShowMessage('Limite de Cr�dito de ' + IntTOStr(limite_credito) + ' dispon�vel')
    else
    begin
     ShowMessage('Limite de Cr�dito atingido!');
     DataModule1.mDisciplinas_.Delete;
     Exit;
    end;


    //Chama fun��o de verifica��o da RN00:
    if VerificaRN02(DataModule1.mDisciplinas_id_disciplina.AsInteger) = False then
    begin
     ShowMessage('A turma da disciplina '+ DataModule1.sql_livre.FieldByName('nome_disciplina').AsString + ' atingiu valor maximo de alunos. Entre na lista de espera para se inscrever na disciplina.');
     Result := False;
     disci_listaEsp := DataModule1.mDisciplinas_id_disciplina.AsInteger;
     pnlListaEspera.Visible := True;
     DataModule1.mDisciplinas_.Delete;
     Exit;
    end;


    //Chama fun��o de verifica��o da RN00:
    if VerificaRN00(DataModule1.mDisciplinas_id_aluno.AsInteger, DataModule1.mDisciplinas_dia_semana.AsInteger, disciplina, horario) = False then
    begin
      ShowMessage('H� choque de horarios entre as disciplinas escolhidas. A disciplina '
          + DataModule1.sql_livre.FieldByName('nome_disciplina').AsString + ' de hor�rio: '
          + DataModule1.sql_livre.FieldByName('horario').AsString + ' conflita com a disciplina '
          + disciplina + ' de hor�rio: '
          + horario);
      Result := False;
      DataModule1.mDisciplinas_.Delete;
      Exit;
    end;

    DataModule1.mDisciplinas_.Next;
  end;
  Result := True;
end;

function TfrmInscricao.VerificaRN00(id_aluno, dia_semana: Integer; out disciplina, horario: String): Boolean;
begin
// VERIFICA RN00 - Choque de hor�ros entre as disciplinas
  DataModule1.DataModuleCreate(nil);
  DataModule1.sql_RN00.Close;
  DataModule1.sql_RN00.ParamByName('id_aluno').AsInteger := id_aluno;
  DataModule1.sql_RN00.ParamByName('dia_semana').AsInteger := dia_semana;
  DataModule1.sql_RN00.Open;

  if DataModule1.sql_RN00.RecordCount > 0 then
  begin
    disciplina := DataModule1.sql_RN00nome_disciplina.AsString;
    horario := DataModule1.sql_RN00horario.AsString;
    Result := False;
  end
  else
    Result := True;
//  CriaComponentesConexao;
//  sql.SQL.Text :=  'select * from tb_aluno_disciplina tad '
//                  +'left join tb_disciplina td on td.id_disciplina = tad.id_disciplina '
//                  +'where tad.id_aluno = :id_aluno '
//                  +'and tad.semestre = 1 and tad.ano = 2024 and tad.dia_semana = :dia_semana '
//                  +'and tad.qtd_aula > 2'; // sql de verifica��o implementada no m�todo
//  sql.ParamByName('id_aluno').AsInteger := id_aluno;
//  sql.ParamByName('dia_semana').AsInteger := dia_semana;
//  sql.Open;
//
//  if sql.RecordCount > 0 then
//  begin
//    disciplina := sql.FieldByName('nome_disciplina').AsString;
//    horario := sql.FieldByName('horario').AsString;
//    Result := False;
//  end
//  else
//    Result := True;

end;

function TfrmInscricao.VerificaRN01(id_aluno: Integer; out limite_credito: Integer): Boolean;
begin
// VERIFICA RN01 - Quantidade de c�ditos do aluno
//  DataModule1.sql_RN01.Close;
//  DataModule1.sql_RN01.ParamByName('id_aluno').AsInteger := id_aluno;
//  DataModule1.sql_RN01.Open;
//
//  if DataModule1.sql_RN01qtd_credito.AsInteger > 20 then
//  begin
//    limite_credito := 0;
//    Result := False;
//  end
//  else
//  begin
//    limite_credito := 20 - DataModule1.sql_RN01qtd_credito.AsInteger;
//    Result := True;
//  end;

//  id_aluno_rn01 := 17; // aluno 'Lucia' que n�o tem mais limite de cr�dito
  CriaComponentesConexao;
  sql.SQL.Text := 'select sum(tad.qtd_aula) as qtd_credito from tb_aluno_disciplina tad where tad.id_aluno = :id_aluno'
                      +' and tad.ano = 2024 and semestre = 1'; // sql de verifica��o implementada no m�todo
  sql.ParamByName('id_aluno').AsInteger := id_aluno;
  sql.Open;

    if sql.Fields[0].AsInteger > 20 then
  begin
    limite_credito := 0;
    Result := False;
  end
  else
  begin
    limite_credito := 20 - sql.Fields[0].AsInteger;
    Result := True;
  end;
end;

function TfrmInscricao.VerificaRN02(id_disciplina: Integer): Boolean;
begin
//  DataModule1.sql_RN02.Close;
//  DataModule1.sql_RN02.ParamByName('id_disciplina').AsInteger  := id_disciplina;
//  DataModule1.sql_RN02.Open;
//
//  if DataModule1.sql_RN02.Fields[0].AsInteger >= 40 then
//    Result := False
//  else
//    Result := True;
   // disciplina de web com 40 alunos
  CriaComponentesConexao;
  sql.SQL.Clear;
  sql.SQL.Text := 'select count(*) as alunos_disciplina from tb_aluno_disciplina tad '
                      +'left join tb_disciplina td on tad.id_disciplina = td.id_disciplina '
                      +'where td.id_disciplina = :id_disciplina and tad.ano = 2024'; // sql de verifica��o implementada no m�todo
  sql.ParamByName('id_disciplina').AsInteger := id_disciplina;
  sql.Open;

  if sql.Fields[0].AsInteger >=40 then
    Result := False
  else
    Result := True;

end;

end.

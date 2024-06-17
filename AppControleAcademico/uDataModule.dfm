object DataModule1: TDataModule1
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    DriverID = 'MySQL'
    VendorLib = 
      'C:\Users\yasmi\OneDrive\Documentos\Embarcadero\Studio\AppControl' +
      'eAcademico\Win32\Debug\lib\libmysql.dll'
    Left = 40
    Top = 88
  end
  object sql_alunos_: TFDQuery
    ChangeAlertName = 'sql_alunos'
    Connection = FDConnection1
    SQL.Strings = (
      ' select * from aluno where id_aluno in (1, 2, 3, 4, 63, 17, 59)')
    Left = 208
    Top = 24
    object sql_alunos_id_aluno: TFDAutoIncField
      FieldName = 'id_aluno'
      Origin = 'id_aluno'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object sql_alunos_nome_aluno: TStringField
      FieldName = 'nome_aluno'
      Origin = 'nome_aluno'
      Required = True
      Size = 50
    end
    object sql_alunos_senha_aluno: TMemoField
      FieldName = 'senha_aluno'
      Origin = 'senha_aluno'
      Required = True
      BlobType = ftMemo
    end
    object sql_alunos_nascimento_aluno: TDateField
      FieldName = 'nascimento_aluno'
      Origin = 'nascimento_aluno'
      Required = True
    end
  end
  object FDTransaction1: TFDTransaction
    Connection = FDConnection1
    Left = 40
    Top = 152
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=db_qsw'
      'User_Name=root'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 40
    Top = 24
  end
  object ds_alunos: TDataSource
    DataSet = sql_alunos_
    Left = 208
    Top = 88
  end
  object sql_disciplinas_: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from tb_disciplina where nome_disciplina like :nome')
    Left = 208
    Top = 160
    ParamData = <
      item
        Name = 'NOME'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
    object sql_disciplinas_id_disciplina: TFDAutoIncField
      FieldName = 'id_disciplina'
      Origin = 'id_disciplina'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object sql_disciplinas_nome_disciplina: TStringField
      FieldName = 'nome_disciplina'
      Origin = 'nome_disciplina'
      Required = True
      Size = 50
    end
    object sql_disciplinas_professor_disciplina: TStringField
      FieldName = 'professor_disciplina'
      Origin = 'professor_disciplina'
      Required = True
      Size = 50
    end
    object sql_disciplinas_dia_semana: TIntegerField
      FieldName = 'dia_semana'
      Origin = 'dia_semana'
      Required = True
    end
    object sql_disciplinas_sala: TStringField
      FieldName = 'sala'
      Origin = 'sala'
      Required = True
      Size = 10
    end
    object sql_disciplinas_horario: TStringField
      FieldName = 'horario'
      Origin = 'horario'
      Required = True
    end
    object sql_disciplinas_qtd_aula: TIntegerField
      FieldName = 'qtd_aula'
      Origin = 'qtd_aula'
      Required = True
    end
  end
  object ds_disciplinas: TDataSource
    DataSet = sql_disciplinas_
    Left = 208
    Top = 224
  end
  object sql_aluno_: TFDQuery
    ChangeAlertName = 'sql_alunos'
    Connection = FDConnection1
    SQL.Strings = (
      ' select * from aluno where id_aluno = :id_aluno')
    Left = 400
    Top = 8
    ParamData = <
      item
        Name = 'ID_ALUNO'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object sql_aluno_id_aluno: TFDAutoIncField
      FieldName = 'id_aluno'
      Origin = 'id_aluno'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object sql_aluno_nome_aluno: TStringField
      FieldName = 'nome_aluno'
      Origin = 'nome_aluno'
      Required = True
      Size = 50
    end
    object sql_aluno_senha_aluno: TMemoField
      FieldName = 'senha_aluno'
      Origin = 'senha_aluno'
      Required = True
      BlobType = ftMemo
    end
    object sql_aluno_nascimento_aluno: TDateField
      FieldName = 'nascimento_aluno'
      Origin = 'nascimento_aluno'
      Required = True
    end
  end
  object sql_periodo_ano_: TFDQuery
    ChangeAlertName = 'sql_periodo_ano'
    Connection = FDConnection1
    SQL.Strings = (
      'select distinct ano'
      'from tb_aluno_disciplina')
    Left = 400
    Top = 72
    object sql_periodo_ano_ano: TIntegerField
      FieldName = 'ano'
      Origin = 'ano'
      Required = True
    end
  end
  object sql_disciplinas_alunos_: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select'#9
      '    a.nome_aluno,'
      '    tad.semestre,'
      '    tad.ano,'
      '    tad.qtd_aula,'
      '    td.nome_disciplina'
      'from tb_aluno_disciplina tad'
      'left join aluno a'
      #9'on a.id_aluno = tad.id_aluno'
      'left join tb_disciplina td'
      #9'on td.id_disciplina = tad.id_disciplina'
      
        'where a.id_aluno = :id and tad.ano = :ano and tad.semestre = :se' +
        'mestre')
    Left = 400
    Top = 152
    ParamData = <
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ANO'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'SEMESTRE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object sql_disciplinas_alunos_nome_aluno: TStringField
      FieldName = 'nome_aluno'
      Origin = 'nome_aluno'
      Required = True
      Size = 50
    end
    object sql_disciplinas_alunos_semestre: TIntegerField
      FieldName = 'semestre'
      Origin = 'semestre'
      Required = True
    end
    object sql_disciplinas_alunos_ano: TIntegerField
      FieldName = 'ano'
      Origin = 'ano'
      Required = True
    end
    object sql_disciplinas_alunos_qtd_aula: TIntegerField
      FieldName = 'qtd_aula'
      Origin = 'qtd_aula'
      Required = True
    end
    object sql_disciplinas_alunos_nome_disciplina: TStringField
      FieldName = 'nome_disciplina'
      Origin = 'nome_disciplina'
      Size = 50
    end
  end
  object ds_disciplinas_alunos: TDataSource
    DataSet = sql_disciplinas_alunos_
    Left = 400
    Top = 208
  end
  object sql_disciplinas_validas_: TFDQuery
    ChangeAlertName = 'sql_disciplinas_validas_'
    Connection = FDConnection1
    SQL.Strings = (
      'select * from tb_disciplina td'
      'where td.id_disciplina in '
      '(select '
      #9'tr.id_disciplina'
      'from tb_pre_requisito tr '
      'where tr.id_pre_req_disciplina in ('
      
        #9'select id_disciplina from tb_aluno_disciplina tad where tad.id_' +
        'aluno = :id_aluno  and tad.aprovado = 1'
      '))'
      'or td.id_disciplina not in ('
      '   select '
      #9'tr.id_disciplina'
      'from tb_pre_requisito tr '
      'where tr.id_pre_req_disciplina not in ('
      
        #9'select id_disciplina from tb_aluno_disciplina tad where tad.id_' +
        'aluno = :id_aluno and tad.aprovado = 1'
      '))'
      'order by td.nome_disciplina asc;')
    Left = 48
    Top = 224
    ParamData = <
      item
        Name = 'ID_ALUNO'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object sql_disciplinas_validas_nome_disciplina: TStringField
      FieldName = 'nome_disciplina'
      Origin = 'nome_disciplina'
      Size = 50
    end
  end
  object sql_livre: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * '
      'from tb_aluno_disciplina ta '
      'where ta.id_aluno = 63'
      'and ano = year(CURRENT_DATE)'
      'and semestre = 1'
      'and dia_semana = 3;')
    Left = 56
    Top = 320
  end
  object mDisciplinas_: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 208
    Top = 320
    object mDisciplinas_id_aluno: TIntegerField
      FieldName = 'id_aluno'
    end
    object mDisciplinas_id_disciplina: TIntegerField
      FieldName = 'id_disciplina'
    end
    object mDisciplinas_semestre: TIntegerField
      FieldName = 'semestre'
    end
    object mDisciplinas_ano: TIntegerField
      FieldName = 'ano'
    end
    object mDisciplinas_qtd_aula: TIntegerField
      FieldName = 'qtd_aula'
    end
    object mDisciplinas_dia_semana: TIntegerField
      FieldName = 'dia_semana'
    end
    object mDisciplinas_aprovado: TBooleanField
      FieldName = 'aprovado'
    end
  end
  object dsDisciplinas: TDataSource
    DataSet = mDisciplinas_
    Left = 208
    Top = 384
  end
  object sql_lista_espera_: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from tb_lista_espera where id_aluno = :id_aluno')
    Left = 568
    Top = 216
    ParamData = <
      item
        Name = 'ID_ALUNO'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object sql_lista_espera_id_aluno: TIntegerField
      FieldName = 'id_aluno'
      Origin = 'id_aluno'
      Required = True
    end
    object sql_lista_espera_id_disciplina: TIntegerField
      FieldName = 'id_disciplina'
      Origin = 'id_disciplina'
      Required = True
    end
    object sql_lista_espera_posicao_lista: TIntegerField
      FieldName = 'posicao_lista'
      Origin = 'posicao_lista'
      Required = True
    end
  end
  object sql_RN02: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      
        'select count(*) as alunos_disciplina from tb_aluno_disciplina ta' +
        'd'
      
        '                                    left join tb_disciplina td o' +
        'n tad.id_disciplina = td.id_disciplina'
      
        '                                    where td.id_disciplina = :id' +
        '_disciplina and tad.ano = 2024')
    Left = 560
    Top = 408
    ParamData = <
      item
        Name = 'ID_DISCIPLINA'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object sql_RN02alunos_disciplina: TLargeintField
      AutoGenerateValue = arDefault
      FieldName = 'alunos_disciplina'
      Origin = 'alunos_disciplina'
      ProviderFlags = []
      ReadOnly = True
    end
  end
  object sql_RN00: TFDQuery
    ChangeAlertName = 'sq'
    Connection = FDConnection1
    SQL.Strings = (
      'select * from tb_aluno_disciplina tad'
      
        'left join tb_disciplina td on td.id_disciplina = tad.id_discipli' +
        'na'
      'where tad.id_aluno = :id_aluno'
      
        'and tad.semestre = 1 and tad.ano = 2024 and tad.dia_semana = :di' +
        'a_semana'
      'and tad.qtd_aula > 2 ')
    Left = 416
    Top = 408
    ParamData = <
      item
        Name = 'ID_ALUNO'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'DIA_SEMANA'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object sql_RN00id_aluno_disciplina: TFDAutoIncField
      FieldName = 'id_aluno_disciplina'
      Origin = 'id_aluno_disciplina'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object sql_RN00id_aluno: TIntegerField
      FieldName = 'id_aluno'
      Origin = 'id_aluno'
      Required = True
    end
    object sql_RN00id_disciplina: TIntegerField
      FieldName = 'id_disciplina'
      Origin = 'id_disciplina'
      Required = True
    end
    object sql_RN00semestre: TIntegerField
      FieldName = 'semestre'
      Origin = 'semestre'
      Required = True
    end
    object sql_RN00ano: TIntegerField
      FieldName = 'ano'
      Origin = 'ano'
      Required = True
    end
    object sql_RN00qtd_aula: TIntegerField
      FieldName = 'qtd_aula'
      Origin = 'qtd_aula'
      Required = True
    end
    object sql_RN00dia_semana: TIntegerField
      FieldName = 'dia_semana'
      Origin = 'dia_semana'
      Required = True
    end
    object sql_RN00aprovado: TBooleanField
      FieldName = 'aprovado'
      Origin = 'aprovado'
      Required = True
    end
    object sql_RN00id_disciplina_1: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'id_disciplina_1'
      Origin = 'id_disciplina'
      ProviderFlags = []
      ReadOnly = True
    end
    object sql_RN00nome_disciplina: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'nome_disciplina'
      Origin = 'nome_disciplina'
      ProviderFlags = []
      ReadOnly = True
      Size = 50
    end
    object sql_RN00professor_disciplina: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'professor_disciplina'
      Origin = 'professor_disciplina'
      ProviderFlags = []
      ReadOnly = True
      Size = 50
    end
    object sql_RN00dia_semana_1: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'dia_semana_1'
      Origin = 'dia_semana'
      ProviderFlags = []
      ReadOnly = True
    end
    object sql_RN00sala: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'sala'
      Origin = 'sala'
      ProviderFlags = []
      ReadOnly = True
      Size = 10
    end
    object sql_RN00horario: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'horario'
      Origin = 'horario'
      ProviderFlags = []
      ReadOnly = True
    end
    object sql_RN00qtd_aula_1: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'qtd_aula_1'
      Origin = 'qtd_aula'
      ProviderFlags = []
      ReadOnly = True
    end
  end
  object sql_RN01: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      
        'select sum(tad.qtd_aula) as qtd_credito from tb_aluno_disciplina' +
        ' tad where tad.id_aluno = :id_aluno'
      'and tad.ano = 2024 and semestre = 1;')
    Left = 488
    Top = 408
    ParamData = <
      item
        Name = 'ID_ALUNO'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object sql_RN01qtd_credito: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'qtd_credito'
      Origin = 'qtd_credito'
      ProviderFlags = []
      ReadOnly = True
      Precision = 32
      Size = 0
    end
  end
  object sql_aluno_disciplina_: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from tb_aluno_disciplina')
    Left = 552
    Top = 32
    object sql_aluno_disciplina_id_aluno: TIntegerField
      FieldName = 'id_aluno'
      Origin = 'id_aluno'
      Required = True
    end
    object sql_aluno_disciplina_id_disciplina: TIntegerField
      FieldName = 'id_disciplina'
      Origin = 'id_disciplina'
      Required = True
    end
    object sql_aluno_disciplina_semestre: TIntegerField
      FieldName = 'semestre'
      Origin = 'semestre'
      Required = True
    end
    object sql_aluno_disciplina_ano: TIntegerField
      FieldName = 'ano'
      Origin = 'ano'
      Required = True
    end
    object sql_aluno_disciplina_qtd_aula: TIntegerField
      FieldName = 'qtd_aula'
      Origin = 'qtd_aula'
      Required = True
    end
    object sql_aluno_disciplina_dia_semana: TIntegerField
      FieldName = 'dia_semana'
      Origin = 'dia_semana'
      Required = True
    end
    object sql_aluno_disciplina_aprovado: TBooleanField
      FieldName = 'aprovado'
      Origin = 'aprovado'
      Required = True
    end
  end
  object dsListaEspera: TDataSource
    DataSet = sql_lista_espera_
    Left = 568
    Top = 280
  end
end

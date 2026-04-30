unit fPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.StdCtrls, Registry;

type
  TPrincipal = class(TForm)
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Panel2: TPanel;
    pgPrincipal: TPageControl;
    TabAnalise: TTabSheet;
    TabMonitor: TTabSheet;
    TabRede: TTabSheet;
    LstPrincipal: TListBox;
    MemoResult: TMemo;
    procedure AdicionarItem(Texto: String; CorLinha: TColor);
    procedure FormCreate(Sender: TObject);
    procedure LstPrincipalDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure SpeedButton6Click(Sender: TObject);
    function VerificaEstrutura: Boolean;
    function EncontrarUnidadeAcrux: string;
    function EspacoEmDiscoLivre(): Int64;
    procedure GetProcessorName;
    procedure GetProcessorCoreCount;
    procedure SpeedButton1Click(Sender: TObject);
    procedure LstPrincipalClick(Sender: TObject);
    procedure LimparItensLista;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TCorItem = class
    Cor: TColor;
    Detalhes: string;
  end;

var
  Principal: TPrincipal;
  sUnidade: String;

implementation

{$R *.dfm}

procedure TPrincipal.AdicionarItem(Texto: String; CorLinha: TColor);
var
  Obj: TCorItem;
begin
  Obj := TCorItem.Create;
  Obj.Cor := CorLinha;
  Obj.Detalhes := Texto;

  LstPrincipal.Items.AddObject(Texto, Obj);
end;

procedure TPrincipal.LimparItensLista;
var
  i: Integer;
begin
  for i := 0 to LstPrincipal.Items.Count - 1 do
    LstPrincipal.Items.Objects[i].Free;

  LstPrincipal.Clear;
end;

procedure TPrincipal.FormCreate(Sender: TObject);
begin
  LstPrincipal.Style := lbOwnerDrawFixed;
  LstPrincipal.ItemHeight := 20;
  LstPrincipal.OnClick := LstPrincipalClick;
  LstPrincipal.Clear;
  MemoResult.Clear;

  sUnidade := EncontrarUnidadeAcrux + '\';
end;

procedure TPrincipal.GetProcessorCoreCount;
var
  SysInfo: SYSTEM_INFO;
begin
  GetSystemInfo(SysInfo);
  AdicionarItem('Quantidade de núcleos : ' +
    IntToStr(SysInfo.dwNumberOfProcessors), clMoneyGreen);
  // Result := SysInfo.dwNumberOfProcessors;
end;

procedure TPrincipal.GetProcessorName;
var
  Reg: TRegistry;
begin
  // Result := 'Informação não disponível';
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('HARDWARE\DESCRIPTION\System\CentralProcessor\0')
    then
    begin
      AdicionarItem('Nome do processador : ' +
        Reg.ReadString('ProcessorNameString'), clMoneyGreen);
      // Result := Reg.ReadString('ProcessorNameString');
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TPrincipal.LstPrincipalDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  Obj: TCorItem;
begin
  Obj := TCorItem(LstPrincipal.Items.Objects[Index]);

  with LstPrincipal.Canvas do
  begin
    Brush.Color := Obj.Cor;
    FillRect(Rect);

    Font.Name := 'Segoe UI';
    Font.Size := 8;
    Font.Color := clBlack;

    if odSelected in State then
    begin
      Brush.Color := clNavy;
      FillRect(Rect);
      Font.Color := clWhite;
    end;

    // TextOut(Rect.Left + 10, Rect.Top + 6, LstPrincipal.Items[Index]);
    TextOut(Rect.Left + 2, Rect.Top + 1, LstPrincipal.Items[Index]);
  end;
end;

procedure TPrincipal.LstPrincipalClick(Sender: TObject);
var
  Obj: TCorItem;
begin
  MemoResult.Clear;

  if LstPrincipal.ItemIndex < 0 then
    Exit;

  Obj := TCorItem(LstPrincipal.Items.Objects[LstPrincipal.ItemIndex]);
  if Assigned(Obj) then
    MemoResult.Lines.Add(Obj.Detalhes);
end;

procedure TPrincipal.SpeedButton1Click(Sender: TObject);
begin
  LimparItensLista;
  MemoResult.Clear;

  AdicionarItem('Espao livre em disco : ' + EspacoEmDiscoLivre(),
    clMoneyGreen);
  LimparItensLista;

  VerificaEstrutura;

  // AdicionarItem(' ', clGray);
  AdicionarItem('Informações do processador ', clGray);
  GetProcessorName;
  GetProcessorCoreCount;
  AdicionarItem('Espaço livre em disco : ' + EspacoEmDiscoLivre(), clGray);
end;

procedure TPrincipal.SpeedButton6Click(Sender: TObject);
begin
  AdicionarItem('Venda Concluída', clMoneyGreen);
  AdicionarItem('Erro no Sistema', clRed);
  AdicionarItem('Em Andamento', clYellow);
  AdicionarItem('Finalizado', clAqua);
end;

function TPrincipal.VerificaEstrutura: Boolean;
var
  sListaDiretorio, sListaArquivos, sListaErros: TStringList;
  i, x: Integer;
begin
  x := 0;
  i := 0;
  Try

    sListaDiretorio := TStringList.Create;
    sListaDiretorio.Clear;

    sListaArquivos := TStringList.Create;
    sListaArquivos.Clear;

    sListaDiretorio.Add(sUnidade + 'C5Client');
    sListaDiretorio.Add(sUnidade + 'C5Client\Acruxmonitor');
    sListaDiretorio.Add(sUnidade + 'C5Client\Acruxmonitor\Services');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\cache\input');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\cache\output');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\cache\deploy');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxMonitor\Services\documento');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\documento\cf-e');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\documento\cf-e\backup');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\documento\ibpt');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\documento\nf-e');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\documento\nf-e\backup');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\documento\nf-e\cancelada');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\documento\nf-e\certificado');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\documento\nf-e\correcao');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\documento\nf-e\dpec');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\documento\nf-e\evento');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\documento\nf-e\gerada');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\documento\nf-e\importado');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\documento\nf-e\inutilizada');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\documento\nf-e\log');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\documento\nf-e\naoimportado');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\documento\nf-e\schemas');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\documento\paf');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxMonitor\Services\log');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\log\aplicacao');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxMonitor\MonitorPDV');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxMonitor\MonitorPDV\API');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxMonitor\MonitorPDV\API\cs');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxMonitor\MonitorPDV\API\de');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxMonitor\MonitorPDV\API\es');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxMonitor\MonitorPDV\API\fr');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxMonitor\MonitorPDV\API\it');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxMonitor\MonitorPDV\API\ja');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxMonitor\MonitorPDV\API\ko');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxMonitor\MonitorPDV\API\pl');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\pt-BR');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\Release');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\Reports');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxMonitor\MonitorPDV\API\ru');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\alpine-x64');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\alpine-x64\native');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\linux');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\linux\lib');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\linux\lib\netcoreapp3.1');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\linux-arm');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\linux-arm\native');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\linux-arm64');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\linux-arm64\native');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\linux-armel');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\linux-armel\native');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\linux-mips64');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\linux-mips64\native');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\linux-musl-x64');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\linux-musl-x64\native');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\linux-x64');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\linux-x64\native');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\linux-x86');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\linux-x86\native');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\osx');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\osx\lib');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\osx\lib\netcoreapp3.1');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\osx-x64');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\osx-x64\native');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\unix');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\unix\lib');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\unix\lib\netcoreapp2.1');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\unix\lib\netcoreapp3.1');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\win');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\win\lib');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\win\lib\netcoreapp2.1');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\win\lib\netcoreapp3.1');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\win\lib\netstandard2.0');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\win-arm');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\win-arm\native');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\win-arm64');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\win-arm64\native');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\win-x64');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\win-x64\native');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\win-x86');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\runtimes\win-x86\native');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxMonitor\MonitorPDV\API\tr');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\zh-Hans');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\API\zh-Hant');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxMonitor\MonitorPDV\Page');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxMonitor\MonitorPDV\Site');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\Site\assets');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\Site\assets\data');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\Site\assets\images');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\Site\assets\images\favicons');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\Site\assets\images\logos');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\MonitorPDV\Site\Release');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxMonitor\WebServices');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxMonitor\WebServices\files');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxMonitor\WebServices\log');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\WebServices\log\aplicacao');
    sListaDiretorio.Add(sUnidade +
      'C5Client\AcruxMonitor\WebServices\log\isapiacruxmonitor_dll');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxMonitor\WebServices');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxUpdate');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxUpdate\CacheInput');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxUpdate\Data');
    sListaDiretorio.Add(sUnidade + 'C5Client\AcruxUpdate\Log');
    sListaDiretorio.Add(sUnidade + 'C5Client\IntegracaoRMS');
    sListaDiretorio.Add(sUnidade + 'C5Client\IntegracaoRMS\nginx');
    sListaDiretorio.Add(sUnidade + 'C5Client\IntegracaoRMS\nginx\html');
    sListaDiretorio.Add(sUnidade + 'C5Client\IntegracaoRMS\nginx\html\assets');

    // Arquivos
    sListaArquivos.Add(sUnidade +
      'C5Client\AcruxMonitor\WebServices\ISAPIAcruxMonitor.dll');
    sListaArquivos.Add(sUnidade +
      'C5Client\AcruxMonitor\WebServices\ISAPIMonitor.dll');
    sListaArquivos.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\AcruxDFePainel.exe');
    sListaArquivos.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\AcruxDFeTools.exe');
    sListaArquivos.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\AcruxMonitorMobileService.exe');
    sListaArquivos.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\AcruxMonitorService.Cancela.exe');
    sListaArquivos.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\AcruxMonitorService.Cancela.ini');
    sListaArquivos.Add(sUnidade +
      '\C5Client\AcruxMonitor\Services\AcruxMonitorService.exe');
    sListaArquivos.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\AcruxMonitorService.MicroTerminal');
    sListaArquivos.Add(sUnidade +
      'C5Client\AcruxMonitor\Services\AcruxMonitorService_timeoutnfe.exe');
    sListaArquivos.Add(sUnidade + 'C5Client\AcruxMonitor\Services\pmtg.dll');
    sListaArquivos.Add(sUnidade + 'C5Client\IntegracaoRMS\IntegracaoRMS.exe');
    sListaArquivos.Add(sUnidade + 'C5Client\AcruxUpdate\AcruxUpdate.exe');

    for i := 0 to sListaDiretorio.Count - 1 do
      if not DirectoryExists(sListaDiretorio[i]) then
      begin
        MemoResult.Lines.Add('Diretório não encontrado : ' +
          sListaDiretorio[i]);
      end;

    for x := 0 to sListaArquivos.Count - 1 do
      if not FileExists(sListaArquivos[x]) then
      begin
        MemoResult.Lines.Add('Diretório não encontrado : ' +
          sListaDiretorio[x]);
      end;

  Finally
    if (sListaArquivos.Count > 0) or (sListaDiretorio.Count > 0) then
      AdicionarItem('Verificando estrutura de arquivos / diretórios', clRed)
    else
      AdicionarItem('Verificando estrutura de arquivos / diretórios',
        clMoneyGreen);

    FreeAndNil(sListaDiretorio);
    FreeAndNil(sListaArquivos);
  End;
end;

function TPrincipal.EncontrarUnidadeAcrux: string;
var
  Drive: Char;
  Caminho: string;
begin
  Result := 'não encontrado';

  for Drive := 'A' to 'Z' do
  begin
    // Verifica se a unidade existe
    if GetDriveType(PChar(Drive + ':\')) <> DRIVE_NO_ROOT_DIR then
    begin
      Caminho := Drive +
        ':\C5Client\AcruxMonitor\Services\Acruxmonitorservice.exe';

      if FileExists(Caminho) then
      begin
        Result := Drive + ':';
        Exit;
      end;
    end;
  end;
end;

function TPrincipal.EspacoEmDiscoLivre: Int64;
var
  S: Int64;
  AmtFree: Int64;
  Total: Int64;
begin
  AmtFree := DiskFree(0);
  Total := DiskSize(0);
  S := (AmtFree div 1024) div 1024;
  Result := S;
end;

end.

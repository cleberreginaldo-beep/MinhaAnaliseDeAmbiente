program TotvsMinhaAnaliseDeAmbiente;

uses
  Vcl.Forms,
  fPrincipal in 'fPrincipal.pas' {Principal},
  Vcl.Themes,
  Vcl.Styles,
  fDm in 'fDm.pas' {Dm: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Glow');
  Application.CreateForm(TPrincipal, Principal);
  Application.CreateForm(TDm, Dm);
  Application.Run;
end.

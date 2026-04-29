program TotvsMinhaAnaliseDeAmbiente;

uses
  Vcl.Forms,
  fPrincipal in 'fPrincipal.pas' {Principal},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Glow');
  Application.CreateForm(TPrincipal, Principal);
  Application.Run;
end.

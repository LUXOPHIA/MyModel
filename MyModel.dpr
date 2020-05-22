program MyModel;

uses
  FMX.Forms,
  Main in 'Main.pas' {Form1},
  LIB.Model.Poin in '_LIBRARY\LIB.Model.Poin.pas',
  LIB.Model.Wire in '_LIBRARY\LIB.Model.Wire.pas',
  LIB.Model.Face in '_LIBRARY\LIB.Model.Face.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

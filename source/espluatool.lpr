program espluatool;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
<<<<<<< HEAD
  Forms, CPortLib10, main_f, espluaaction, espluaproperties, esplualog
=======
  Forms, CPortLib10, main_f, espluaaction
>>>>>>> 0bfc61bca127bbf56f8ce63db5663cd99e9b60d7
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.


unit main_f;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, CPortCtl, CPort, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Crt, espluaaction, LCLType, espluaproperties;

type

  { TForm1 }

  TForm1 = class(TForm)
    Label2: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    ProgressBar1: TProgressBar;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

    fESPProperties: tespluaproperties;
    function getAllFile(const v_fn: string; v_p: string; v_b: integer): rResult;
    function GetParam(const v_param: string): string;
    function isGetAllFileContent: boolean;
    function isWrite: boolean;
    function isWriteCompile: boolean;
    function ParamExists(const v_param: string): boolean;
    procedure RefreshCaption;
    procedure ShowResult(const v_res: rResult);
    function WriteFileAction(const v_fn: string; v_p: string; v_b: integer; const v_compile, v_compare: boolean): rResult;

    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }


function TForm1.ParamExists(const v_param: string): boolean;
var
  r: integer;
begin
  Result := True;
  r := 0;
  while ParamStr(r) <> '' do
  begin
    if AnsiUpperCase(v_param) = AnsiUpperCase(ParamStr(r)) then
    begin
      exit;
    end;
    Inc(r);
  end;
  Result := False;
end;

function TForm1.GetParam(const v_param: string): string;
var
  r: integer;
begin
  r := 0;
  while ParamStr(r) <> '' do
  begin
    if AnsiUpperCase(v_param) = AnsiUpperCase(ParamStr(r)) then
    begin
      Result := ParamStr(r + 1);
      break;
    end;
    Inc(r);
  end;
end;


function TForm1.isWrite: boolean;
var
  i: integer;
begin
  Result := ParamExists('-p') and ParamExists('-b') and ParamExists('-w') and trystrtoint(getparam('-b'), i);
end;


function TForm1.isWriteCompile: boolean;
var
  i: integer;
begin
  Result := ParamExists('-p') and ParamExists('-b') and ParamExists('-wc') and trystrtoint(getparam('-b'), i);
end;

function TForm1.isGetAllFileContent: boolean;
var
  i: integer;
begin
  Result := ParamExists('-p') and ParamExists('-b') and ParamExists('-ga') and trystrtoint(getparam('-b'), i);
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  fESPProperties := tespluaproperties.Create();
  label2.Caption := '';
  RefreshCaption;
  Timer1.Enabled := True;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fESPProperties);
end;


procedure TForm1.ShowResult(const v_res: rResult);
begin
  if v_res.RES <> 0 then
    MessageDlg(Caption, v_res.MSG, mtConfirmation, [mbOK], 0);
end;


procedure TForm1.RefreshCaption;

begin
  if isWrite then
  begin
    Caption := Caption + ' - ' + fESPProperties.getLabWriteFile;
  end;
  if isWriteCompile then
  begin
    Caption := Caption + ' - ' + fESPProperties.getLabWriteFileCompile;
  end;
  if isGetAllFileContent then
    Caption := Caption + ' - ' + fESPProperties.getLabAllFileContent;

  panel2.Caption := '  ' + Caption;
end;



function TForm1.WriteFileAction(const v_fn: string; v_p: string; v_b: integer; const v_compile, v_compare: boolean): rResult;
var
  t: TStringList;
  espaction: tespluaaction;
begin
  if fileexists(v_fn) then
  begin
    t := TStringList.Create;
    t.LoadFromFile(v_fn);
    espaction := tespluaaction.Create(self, v_p, v_b);
    espaction.ProgressBar := Progressbar1;
    espaction.ProgressLabel := label2;
    if v_compile then
      Result := espaction.writeFileAndCompile(extractfilename(v_fn), t.Text, v_compare)
    else
      Result := espaction.WriteFile(extractfilename(v_fn), t.Text, v_compare);

    FreeAndNil(t);
  end
  else
  begin
    Result.MSG := v_fn + ': ' + fESPProperties.getLabFileNotExists;
    Result.RES := 1;
  end;
end;

function TForm1.getAllFile(const v_fn: string; v_p: string; v_b: integer): rResult;
var
  t: TStringList;
  sc: TStringList;
  espaction: tespluaaction;
  r: integer;
begin
  t := TStringList.Create;
  sc := TStringList.Create;
  espaction := tespluaaction.Create(self, v_p, v_b);
  espaction.ProgressBar := Progressbar1;
  espaction.ProgressLabel := label2;
  Result := espaction.getFileList(t);
  r := 0;
  while (r <> t.Count) and (Result.RES = 0) do
  begin
    Result := espaction.getFile(t[r], sc);
    sc.SaveToFile(v_fn + t[r]);
    Inc(r);
  end;
  FreeAndNil(sc);
  FreeAndNil(t);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  r: rResult;
  fn, port: string;
  bt: integer;
  comp: boolean;
begin
  Timer1.Enabled := False;


  if isWrite then
  begin
    fn := getparam('-w');
    port := getparam('-p');
    bt := StrToInt(getparam('-b'));
    comp := paramexists('-c');
    r := WriteFileAction(fn, port, bt, False, comp);
  end
  else
  if isWriteCompile then
  begin
    fn := getparam('-wc');
    port := getparam('-p');
    bt := StrToInt(getparam('-b'));
    comp := paramexists('-c');
    r := WriteFileAction(fn, port, bt, True, comp);
  end
  else
  if isGetAllFileContent then
  begin
    fn := getparam('-ga');
    port := getparam('-p');
    bt := StrToInt(getparam('-b'));
    r := GetAllFile(fn, port, bt);
  end
  else
  begin
    r.MSG := fESPProperties.getLabCmdError;
    r.RES := 1;
  end;

  ShowResult(r);
  ExitCode := r.RES;
  Close;

end;

end.

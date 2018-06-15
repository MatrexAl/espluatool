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
    ProgressBar1: TProgressBar;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

    fESPProperties: tespluaproperties;
    function ConnectStr(const s, s1, s2: string): string;
    function getAllFile(v_fn: string; v_p: string; v_b: integer): rResult;
    function GetBitrate: integer;
    function GetCompare: boolean;
    function getFile(v_fn: string; v_p: string; v_b: integer; const v_node_fn: string): rResult;
    function GetFile: string;
    function GetListFolder: string;
    function GetParam(const v_param: string): string;
    function GetPort: string;
    function GetWriteFileName: string;
    function isBasicParam: boolean;
    function isGetAllFileContent: boolean;
    function isGetFileContent: boolean;
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



function TForm1.isBasicParam: boolean;
var
  i: integer;
begin
  Result := ParamExists('-p') and ParamExists('-b') and trystrtoint(getparam('-b'), i);
end;

function TForm1.isWrite: boolean;
begin
  Result := isBasicParam and ParamExists('-w');
end;

function TForm1.isWriteCompile: boolean;
begin
  Result := isBasicParam and ParamExists('-wc');
end;

function TForm1.isGetAllFileContent: boolean;
begin
  Result := isBasicParam and ParamExists('-ga');
end;

function TForm1.isGetFileContent: boolean;
begin
  Result := isBasicParam and ParamExists('-g') and ParamExists('-f');
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

function TForm1.ConnectStr(const s, s1, s2: string): string;
begin
  result:='';
  if s<>'' then result:=result+s+', ';
  if s1<>'' then result:=result+s1+', ';
  if s2<>'' then result:=result+s2+', ';
  if result<>'' then setlength(result, length(result)-2);
end;

procedure TForm1.RefreshCaption;
var
  s: string;
begin
  s := '';
  if GetCompare then
    s := fESPProperties.getLabCompare;
  if isWrite then
  begin
    Caption := Caption + ' - ' + ConnectStr(fESPProperties.getLabWriteFile, s, '');
  end;
  if isWriteCompile then
  begin
    Caption := Caption + ' - ' + ConnectStr(fESPProperties.getLabWriteFile, s, fESPProperties.getLabCompile);
  end;
  if isGetAllFileContent then
    Caption := Caption + ' - ' + ConnectStr(fESPProperties.getLabAllFileContent, '','');
  if isGetFileContent then
    Caption := Caption + ' - ' + ConnectStr(fESPProperties.getLabFileContent, '','');
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



function TForm1.getFile(v_fn: string; v_p: string; v_b: integer; const v_node_fn: string): rResult;
var
  espaction: tespluaaction;
  sc: TStringList;
begin
  sc := TStringList.Create;
  v_fn := includetrailingpathdelimiter(v_fn);
  espaction := tespluaaction.Create(self, v_p, v_b);
  espaction.ProgressBar := Progressbar1;
  espaction.ProgressLabel := label2;
  Result := espaction.getFile(v_node_fn, sc);
  sc.SaveToFile(v_fn + v_node_fn);
  FreeAndNil(sc);
  FreeAndNil(espaction);
end;

function TForm1.getAllFile(v_fn: string; v_p: string; v_b: integer): rResult;
var
  t: TStringList;
  espaction: tespluaaction;
  r: integer;
begin
  if v_fn <> '' then
  begin
    v_fn := includetrailingpathdelimiter(v_fn);
    if forcedirectories(v_fn) then
    begin
      t := TStringList.Create;
      espaction := tespluaaction.Create(self, v_p, v_b);
      espaction.ProgressBar := Progressbar1;
      espaction.ProgressLabel := label2;
      Result := espaction.getFileList(t);
      FreeAndNil(espaction);
      r := 0;
      while (r <> t.Count) and (Result.RES = 0) do
      begin
        Result := getFile(v_fn, v_p, v_b, t[r]);
        Inc(r);
      end;
      FreeAndNil(t);
    end
    else
    begin
      Result.MSG := v_fn + ': ' + fESPProperties.getLabCanCreatePath;
      Result.RES := 1;
    end;
  end
  else
  begin
    Result.MSG := fESPProperties.getLabNullPath;
    Result.RES := 1;
  end;
end;


function TForm1.GetPort: string;
begin
  Result := getparam('-p');
end;

function TForm1.GetBitrate: integer;
begin
  Result := StrToInt(getparam('-b'));
end;

function TForm1.GetWriteFileName: string;
begin
  Result := getparam('-w');
  if Result = '' then
    Result := getparam('-wc');
end;

function TForm1.GetListFolder: string;
begin
  Result := getparam('-ga');
  if Result = '' then
    Result := getparam('-g');
end;

function TForm1.GetFile: string;
begin
  Result := getparam('-f');
end;

function TForm1.GetCompare: boolean;
begin
  Result := paramexists('-c');
end;




procedure TForm1.Timer1Timer(Sender: TObject);
var
  r: rResult;
begin
  Timer1.Enabled := False;

  if isWrite then
    r := WriteFileAction(GetWriteFileName, GetPort, GetBitrate, False, GetCompare)
  else
  if isWriteCompile then
    r := WriteFileAction(GetWriteFileName, GetPort, GetBitrate, True, GetCompare)
  else
  if isGetAllFileContent then
    r := GetAllFile(GetListFolder, GetPort, GetBitrate)
  else
  if isGetFileContent then
    r := GetFile(GetListFolder, GetPort, GetBitrate, GetFile)
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

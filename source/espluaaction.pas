unit espluaaction;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, CPortCtl, CPort, Crt, StdCtrls, Forms;

type
  rResult = record
    MSG: string;
    RES: integer;
  end;


type

  { TForm1 }

  { TESPLuaAction }

  TESPLuaAction = class
  private
    ComDataPacket: TComDataPacket;
    ComPort: TComPort;
    fReadStr: tmemo;
    fForm: TForm;
    function CutResultLine(const v_script: string): rResult;
    function ExecuteLuaScript(const v_script: TStrings; const v_timeout: longword): rResult; overload;
    function ExecuteLuaScript(const v_script: string; const v_timeout: longword): rResult; overload;
    function ExecuteLuaStr(const v_script: string): rResult;
    function isNormalStr(const str: string): boolean;
    procedure ClearResult(var v_res: rResult);
    function NormalizeStr(const v_str: string): string;
    procedure OnPacket(Sender: TObject; const Str: string);
    function WaitLineEnd(const v_timeout: longword): rResult;
    function WaitLine(const v_line: string; const v_timeout: longword): rResult;
    { private declarations }
  public
    { public declarations }
    function getFile(const v_filename: string): rResult;
    function getFileList(): rResult;
    function writeFile(const v_filename: string; const v_data: string): rResult;
    function getReadStr: string;
    function Open: rResult;
    function Close: rResult;
    constructor Create(AOwner: TComponent; const v_port: string; const v_bitrate: integer);
    destructor Destroy; override;
  end;

implementation

{ TESPLuaAction }

procedure TESPLuaAction.ClearResult(var v_res: rResult);
begin
  v_res.MSG := 'OK';
  v_res.RES := 0;
end;

function TESPLuaAction.isNormalStr(const str: string): boolean;
begin
  Result := True;
end;

procedure TESPLuaAction.OnPacket(Sender: TObject; const Str: string);
begin
  if isNormalStr(str) then
  begin
    fReadStr.Lines.Text := fReadStr.Lines.Text + str;
  end;
end;


function TESPLuaAction.NormalizeStr(const v_str: string): string;
begin
  Result := v_str;
end;

function TESPLuaAction.getReadStr: string;
begin
  Result := fReadStr.Lines.Text;
end;

function TESPLuaAction.WaitLine(const v_line: string; const v_timeout: longword): rResult;
var
  d: longword;
begin
  ClearResult(Result);
  fReadStr.Clear;
  ComDataPacket.OnPacket := @OnPacket;
  d := 0;
  while d < v_timeout do
  begin
    application.ProcessMessages;
    delay(10);
    d := d + 10;
    if pos(AnsiUpperCase(v_line), AnsiUpperCase(getReadStr)) <> 0 then
      exit;
  end;
  Result.MSG := 'TIMEOUT';
  Result.RES := 1;
end;



function TESPLuaAction.WaitLineEnd(const v_timeout: longword): rResult;
var
  oldstr: string;
  d: longword;
begin
  ClearResult(Result);
  fReadStr.Clear;
  ComDataPacket.OnPacket := @OnPacket;
  oldstr := '';
  d := 0;
  while (d < v_timeout) do
  begin
    application.ProcessMessages;
    delay(10);
    if (oldstr = getReadStr) then
      d := d + 10
    else
    begin
      d := 0;
      oldstr := getReadStr;
    end;
  end;
end;


function TESPLuaAction.CutResultLine(const v_script: string): rResult;
var
  s: string;
  p, e: integer;
begin
  s := getReadStr;
  p := pos(AnsiUpperCase(v_script), AnsiUpperCase(s));
  if p = 0 then
    p := 1
  else
    p := p + length(v_script);
  e := pos(#13#10 + '>' + #32, s);
  if e = 0 then
    e := length(s) - p
  else
    e := length(s) - p - 4 + 1;
  s := copy(s, p, e);
  fReadStr.Text := s;
end;

function TESPLuaAction.ExecuteLuaStr(const v_script: string): rResult;
begin
  ClearResult(Result);
  comport.WriteStr(v_script);
end;

function TESPLuaAction.ExecuteLuaScript(const v_script: string; const v_timeout: longword): rResult;
var
  t: TStringList;
begin
  t := TStringList.Create;
  t.Add(v_script);
  Result := ExecuteLuaScript(t, v_timeout);
  FreeAndNil(t);
end;


function TESPLuaAction.ExecuteLuaScript(const v_script: TStrings; const v_timeout: longword): rResult;
var
  r: integer;
begin
  Result := Open;
  if Result.RES = 0 then
  begin
    r := 0;
    while (r <> v_script.Count) and (Result.RES = 0) do
    begin
      Result := ExecuteLuaStr(v_script[r] + #13#10);
      if Result.RES = 0 then
        Result := WaitLineEnd(v_timeout);
      if Result.RES = 0 then
        CutResultLine(v_script.Text);
      Inc(r);
    end;
  end;
  Close;
end;

function TESPLuaAction.getFile(const v_filename: string): rResult;
var
  cmd: string;
begin
  cmd := 'if file.open("' + v_filename + '") then print(file.read()) file.close() end';
  Result := ExecuteLuaScript(cmd, 500);
end;

function TESPLuaAction.getFileList: rResult;
var
  cmd: string;
begin
  cmd := 'l = file.list(); for k in pairs(l) do print(k) end';
  Result := ExecuteLuaScript(cmd, 500);
end;

function TESPLuaAction.writeFile(const v_filename: string; const v_data: string): rResult;
var
  t: TStringList;
  i: TStringList;
  r: integer;
begin
  t := TStringList.Create;
  i := TStringList.Create;
  i.Text := v_data;


  t.add('file.remove("' + v_filename + '");');
  t.add('file.open("' + v_filename + '","w+");');
  t.add('w = file.writeline');

  r := 0;
  while r <> i.Count do
  begin
    t.add('w([==[' + i[r] + ']==]);');
    Inc(r);
  end;

  t.add('file.close();');
  Result := ExecuteLuaScript(t, 500);

  FreeAndNil(t);
  FreeAndNil(i);

  if Result.RES = 0 then
  begin
    Result := ExecuteLuaScript('dofile("' + v_filename + '");', 1000);
    if getReadStr <> '' then
    begin
      Result.MSG := getReadStr;
      Result.RES := 3;
    end;
  end;

end;


function TESPLuaAction.Open: rResult;
begin
  ClearResult(Result);
  try
    ComPort.Open;
    ComPort.SetRTS(True);
    delay(500);
    ComPort.SetRTS(False);
    Result := WaitLine('NodeMCU', 5000);
    if Result.RES = 0 then
      delay(500);
  except
    On E: Exception do
    begin
      Result.MSG := E.Message;
      Result.RES := 2;
    end;
  end;

end;

function TESPLuaAction.Close: rResult;
begin
  ClearResult(Result);
  if comport.Connected then
    ComPort.Close;
end;

constructor TESPLuaAction.Create(AOwner: TComponent; const v_port: string; const v_bitrate: integer);
begin
  ComPort := TComPort.Create(AOwner);
  ComDataPacket := TComDataPacket.Create(AOwner);
  ComDataPacket.ComPort := ComPort;
  ComPort.Port := v_port;
  ComPort.BaudRate := StrToBaudRate(IntToStr(v_bitrate));
  fReadStr := tmemo.Create(AOwner);
  fReadStr.Left := -1000;
  fReadStr.WordWrap := False;
  fReadStr.Parent := (AOwner as TForm);
end;

destructor TESPLuaAction.Destroy;
begin
  Close;
  FreeAndNil(fReadStr);
  FreeAndNil(ComPort);
  FreeAndNil(ComDataPacket);
  inherited Destroy;
end;

end.

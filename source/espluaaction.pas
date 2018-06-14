unit espluaaction;

{$mode objfpc}{$H+}

interface

uses
<<<<<<< HEAD
  Classes, SysUtils, CPortCtl, CPort, Crt, StdCtrls, Forms, ComCtrls, espluaproperties, ESPLUALog;
=======
  Classes, SysUtils, CPortCtl, CPort, Crt, StdCtrls, Forms;
>>>>>>> 0bfc61bca127bbf56f8ce63db5663cd99e9b60d7

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
<<<<<<< HEAD
    fESPProperties: tESPLUAProperties;
    fESPLog: tESPLUALog;
    function CalcTimeOut(const v_line: string; const v_def: integer): integer;
    procedure ClearFreeLineInReasStr;
    function CutResultLine(const v_script: string): rResult;
    function ExecuteLuaScript(const v_script: string; const v_timeout: longword; const v_lab: string): rResult; overload;
    function ExecuteLuaScript(const v_script: TStrings; const v_timeout: longword; const v_lab: string): rResult; overload;
=======
    function CutResultLine(const v_script: string): rResult;
    function ExecuteLuaScript(const v_script: TStrings; const v_timeout: longword): rResult; overload;
    function ExecuteLuaScript(const v_script: string; const v_timeout: longword): rResult; overload;
>>>>>>> 0bfc61bca127bbf56f8ce63db5663cd99e9b60d7
    function ExecuteLuaStr(const v_script: string): rResult;
    function isNormalStr(const str: string): boolean;
    procedure ClearResult(var v_res: rResult);
    function NormalizeStr(const v_str: string): string;
    procedure OnPacket(Sender: TObject; const Str: string);
    function WaitLineEnd(const v_timeout: longword): rResult;
    function WaitLine(const v_line: string; const v_timeout: longword): rResult;
<<<<<<< HEAD
    procedure RefreshProgress(const v_size, v_pos: integer; const v_lab: string);
    function getReadStr: string;
    function Open: rResult;
    function Close: rResult;
    function writeFileAction(const v_filename: string; const v_data: string; const v_compile: boolean): rResult;
    { private declarations }
  public
    { public declarations }
    ProgressBar: TProgressBar;
    ProgressLabel: TLabel;
    function getFile(const v_filename: string; var v_res: string): rResult;
    function getFileList(var v_res: string): rResult;
    function writeFile(const v_filename: string; const v_data: string): rResult;
    function writeFileAndCompile(const v_filename: string; const v_data: string): rResult;
=======
    { private declarations }
  public
    { public declarations }
    function getFile(const v_filename: string): rResult;
    function getFileList(): rResult;
    function writeFile(const v_filename: string; const v_data: string): rResult;
    function getReadStr: string;
    function Open: rResult;
    function Close: rResult;
>>>>>>> 0bfc61bca127bbf56f8ce63db5663cd99e9b60d7
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

<<<<<<< HEAD
procedure TESPLuaAction.RefreshProgress(const v_size, v_pos: integer; const v_lab: string);
var
  s: string;
begin
  if ProgressBar <> nil then
  begin
    ProgressBar.Max := v_size;
    ProgressBar.Position := v_pos;
    ProgressBar.Repaint;
    application.ProcessMessages;
  end;

  s := '';
  if (v_size <> 0) and (v_pos <> 0) then
    s := ' [' + IntToStr(v_pos) + ' из ' + IntToStr(v_size) + ']';
  if ProgressLabel <> nil then
  begin
    ProgressLabel.Caption := v_lab + s;
    ProgressLabel.Repaint;
    application.ProcessMessages;
  end;

  fESPLog.Add(v_lab + s);
end;

=======
>>>>>>> 0bfc61bca127bbf56f8ce63db5663cd99e9b60d7


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

<<<<<<< HEAD
=======

>>>>>>> 0bfc61bca127bbf56f8ce63db5663cd99e9b60d7
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
<<<<<<< HEAD
  fESPLog.Add(v_script);
end;

function TESPLuaAction.ExecuteLuaScript(const v_script: string; const v_timeout: longword; const v_lab: string): rResult;
=======
end;

function TESPLuaAction.ExecuteLuaScript(const v_script: string; const v_timeout: longword): rResult;
>>>>>>> 0bfc61bca127bbf56f8ce63db5663cd99e9b60d7
var
  t: TStringList;
begin
  t := TStringList.Create;
  t.Add(v_script);
<<<<<<< HEAD
  Result := ExecuteLuaScript(t, v_timeout, v_lab);
  FreeAndNil(t);
end;

function TESPLuaAction.CalcTimeOut(const v_line: string; const v_def: integer): integer;
begin
  Result := v_def;
  if pos('w([==[', v_line) = 1 then
    Result := fESPProperties.getWriteDelay;
end;


function TESPLuaAction.ExecuteLuaScript(const v_script: TStrings; const v_timeout: longword; const v_lab: string): rResult;
=======
  Result := ExecuteLuaScript(t, v_timeout);
  FreeAndNil(t);
end;


function TESPLuaAction.ExecuteLuaScript(const v_script: TStrings; const v_timeout: longword): rResult;
>>>>>>> 0bfc61bca127bbf56f8ce63db5663cd99e9b60d7
var
  r: integer;
begin
  Result := Open;
  if Result.RES = 0 then
  begin
    r := 0;
    while (r <> v_script.Count) and (Result.RES = 0) do
    begin
<<<<<<< HEAD
      RefreshProgress(v_script.Count - 1, r, v_lab);
      Result := ExecuteLuaStr(v_script[r] + #13#10);
      if Result.RES = 0 then
      begin
        Result := WaitLineEnd(CalcTimeOut(v_script[r], v_timeout));
        if Result.RES = 0 then
          CutResultLine(v_script.Text);
      end;
=======
      Result := ExecuteLuaStr(v_script[r] + #13#10);
      if Result.RES = 0 then
        Result := WaitLineEnd(v_timeout);
      if Result.RES = 0 then
        CutResultLine(v_script.Text);
>>>>>>> 0bfc61bca127bbf56f8ce63db5663cd99e9b60d7
      Inc(r);
    end;
  end;
  Close;
end;

<<<<<<< HEAD
function TESPLuaAction.getFile(const v_filename: string; var v_res: string): rResult;
var
  cmd: string;
begin
  fESPLog.Clear;
  v_res := '';
  cmd := 'if file.open("' + v_filename + '") then print(file.read()) file.close() end';
  Result := ExecuteLuaScript(cmd, fESPProperties.getWaitResultDelay, v_filename + ': ' + fESPProperties.getLabFile);
  if Result.RES = 0 then
  begin
    ClearFreeLineInReasStr;
    v_res := getReadStr;
  end;
end;


procedure TESPLuaAction.ClearFreeLineInReasStr;
var
  r: integer;
begin
  r := 0;
  while r <> fReadStr.Lines.Count do
  begin
    if fReadStr.Lines[r] = '' then
    begin
      fReadStr.Lines.Delete(r);
    end
    else
      Inc(r);
  end;
end;

function TESPLuaAction.getFileList(var v_res: string): rResult;
var
  cmd: string;
begin
  fESPLog.Clear;
  v_res := '';
  cmd := 'l = file.list(); for k in pairs(l) do print(k) end';
  Result := ExecuteLuaScript(cmd, fESPProperties.getWaitResultDelay, fESPProperties.getLabFileList);
  if Result.RES = 0 then
  begin
    ClearFreeLineInReasStr;
    v_res := getReadStr;
  end;
end;

function TESPLuaAction.writeFileAndCompile(const v_filename: string; const v_data: string): rResult;
begin
  fESPLog.Clear;
  Result := writeFileAction(v_filename, v_data, True);
end;


function TESPLuaAction.writeFile(const v_filename: string; const v_data: string): rResult;
begin
  fESPLog.Clear;
  Result := writeFileAction(v_filename, v_data, False);
end;

function TESPLuaAction.writeFileAction(const v_filename: string; const v_data: string; const v_compile: boolean): rResult;
=======
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
>>>>>>> 0bfc61bca127bbf56f8ce63db5663cd99e9b60d7
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
<<<<<<< HEAD
  Result := ExecuteLuaScript(t, fESPProperties.getWaitResultDelay, v_filename + ': ' + fESPProperties.getLabWriteFile);
=======
  Result := ExecuteLuaScript(t, 500);
>>>>>>> 0bfc61bca127bbf56f8ce63db5663cd99e9b60d7

  FreeAndNil(t);
  FreeAndNil(i);

<<<<<<< HEAD

  if v_compile then
  begin
    if Result.RES = 0 then
    begin
      Result := ExecuteLuaScript('dofile("' + v_filename + '");', fESPProperties.getWaitResultDelayCompile, v_filename + ': ' + v_filename + ': ' + fESPProperties.getLabCompile);
      if getReadStr <> '' then
      begin
        Result.MSG := getReadStr;
        Result.RES := 3;
      end;
=======
  if Result.RES = 0 then
  begin
    Result := ExecuteLuaScript('dofile("' + v_filename + '");', 1000);
    if getReadStr <> '' then
    begin
      Result.MSG := getReadStr;
      Result.RES := 3;
>>>>>>> 0bfc61bca127bbf56f8ce63db5663cd99e9b60d7
    end;
  end;

end;


<<<<<<< HEAD



=======
>>>>>>> 0bfc61bca127bbf56f8ce63db5663cd99e9b60d7
function TESPLuaAction.Open: rResult;
begin
  ClearResult(Result);
  try
<<<<<<< HEAD
    RefreshProgress(0, 0, ComPort.Port + ': ' + fESPProperties.GetLabOpen);
    ComPort.Open;
    ComPort.SetRTS(True);
    delay(fESPProperties.getOpenRTSDelay);
    ComPort.SetRTS(False);
    RefreshProgress(0, 0, ComPort.Port + ': ' + fESPProperties.GetLabWaitNodeMCU);
    Result := WaitLine('NodeMCU', fESPProperties.GetWaitLineDelay);
    if Result.RES = 0 then
      delay(fESPProperties.getWaitResultDelayCompile);
=======
    ComPort.Open;
    ComPort.SetRTS(True);
    delay(500);
    ComPort.SetRTS(False);
    Result := WaitLine('NodeMCU', 5000);
    if Result.RES = 0 then
      delay(500);
>>>>>>> 0bfc61bca127bbf56f8ce63db5663cd99e9b60d7
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
<<<<<<< HEAD
  begin
    RefreshProgress(0, 0, ComPort.Port + ': ' + fESPProperties.GetLabClose);
    ComPort.Close;
  end;
=======
    ComPort.Close;
>>>>>>> 0bfc61bca127bbf56f8ce63db5663cd99e9b60d7
end;

constructor TESPLuaAction.Create(AOwner: TComponent; const v_port: string; const v_bitrate: integer);
begin
<<<<<<< HEAD
  fESPProperties := tESPLUAProperties.Create;
  ComPort := TComPort.Create(AOwner);
  ComDataPacket := TComDataPacket.Create(AOwner);
  ComDataPacket.ComPort := ComPort;
  ComPort.Port := AnsiUpperCase(v_port);
=======
  ComPort := TComPort.Create(AOwner);
  ComDataPacket := TComDataPacket.Create(AOwner);
  ComDataPacket.ComPort := ComPort;
  ComPort.Port := v_port;
>>>>>>> 0bfc61bca127bbf56f8ce63db5663cd99e9b60d7
  ComPort.BaudRate := StrToBaudRate(IntToStr(v_bitrate));
  fReadStr := tmemo.Create(AOwner);
  fReadStr.Left := -1000;
  fReadStr.WordWrap := False;
  fReadStr.Parent := (AOwner as TForm);
<<<<<<< HEAD
  ProgressBar := nil;
  ProgressLabel := nil;
  fESPLog := tESPLUALog.Create;
=======
>>>>>>> 0bfc61bca127bbf56f8ce63db5663cd99e9b60d7
end;

destructor TESPLuaAction.Destroy;
begin
  Close;
  FreeAndNil(fReadStr);
  FreeAndNil(ComPort);
  FreeAndNil(ComDataPacket);
<<<<<<< HEAD
  FreeAndNil(fESPProperties);
  FreeAndNil(fESPLog);
=======
>>>>>>> 0bfc61bca127bbf56f8ce63db5663cd99e9b60d7
  inherited Destroy;
end;

end.

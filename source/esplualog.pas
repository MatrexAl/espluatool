unit esplualog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type



  { TESPLuaLog }

  TESPLuaLog = class
  private
    function getLogFileName: string;
    { private declarations }
  public
    { public declarations }
    procedure Clear;
    procedure Add(const v_msg: string);
    constructor Create();
    destructor Destroy; override;
  end;


implementation

{ TESPLuaLog }

function TESPLuaLog.getLogFileName: string;
begin
  Result := extractfilepath(ParamStr(0)) + 'log.log';
end;

procedure TESPLuaLog.Clear;
begin
  if fileexists(getLogFileName) then
    DeleteFile(getLogFileName);
end;

procedure TESPLuaLog.Add(const v_msg: string);
var
  t: TStringList;
  s: string;
begin
  if v_msg <> '' then
  begin
    t := TStringList.Create;
    if fileexists(getLogFileName) then
      t.loadfromfile(getLogFileName);
    s := v_msg;
    s := v_msg;
    s := StringReplace(s, #13#10, '', [rfReplaceAll, rfIgnoreCase]);
    t.Add(datetimetostr(now) + ' - ' + s);
    t.SaveToFile(getLogFileName);
    FreeAndNil(t);
  end;
end;

constructor TESPLuaLog.Create;
begin

end;

destructor TESPLuaLog.Destroy;
begin
  inherited Destroy;
end;

end.

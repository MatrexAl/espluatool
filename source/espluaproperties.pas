unit espluaproperties;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TESPLuaProperties }

  TESPLuaProperties = class
  private
    function getLabCompare: string;
    { private declarations }
  public
    { public declarations }
    function getLabAllFileContent: string;
    function getLabWriteFile: string;
    function getLabWriteFileCompile: string;
    function getOpenRTSDelay: integer;
    function getWaitResultDelay: integer;
    function getWaitResultDelayCompile: integer;
    function getWaitLineDelay: integer;
    function getWriteDelay: integer;
    function getLabFile: string;
    function getLabFileList: string;
    function getLabCompile: string;
    function getLabClose: string;
    function getLabOpen: string;
    function getLabWaitNodeMCU: string;
    function getLabFileNotExists: string;
    function getLabCmdError: string;
    constructor Create();
    destructor Destroy; override;
  end;


implementation

{ TESPLuaProperties }

function TESPLuaProperties.getLabAllFileContent: string;
begin
  Result := 'Сохраняю содержимое всех файлов';
end;

function TESPLuaProperties.getLabCmdError: string;
begin
  Result := 'Ошибка командной строки';
end;


function TESPLuaProperties.getLabFileNotExists: string;
begin
  Result := 'Файл не существует';
end;


function TESPLuaProperties.getLabCompare: string;
begin
  Result := 'Сравниваю';
end;

function TESPLuaProperties.getLabCompile: string;
begin
  Result := 'Компилирую';
end;

function TESPLuaProperties.getLabWriteFile: string;
begin
  Result := 'Записываю скрипт';
end;

function TESPLuaProperties.getLabWriteFileCompile: string;
begin
  Result := getLabWriteFile + ', ' + getLabCompile;
end;

function TESPLuaProperties.getLabFileList: string;
begin
  Result := 'Получаю список файлов';
end;

function TESPLuaProperties.getLabFile: string;
begin
  Result := 'Получаю содержимое';
end;

function TESPLuaProperties.getLabOpen: string;
begin
  Result := 'Открываю порт';
end;

function TESPLuaProperties.getLabWaitNodeMCU: string;
begin
  Result := 'Жду отклика';
end;

function TESPLuaProperties.getLabClose: string;
begin
  Result := 'Закрываю порт';
end;

// время задержки при записи данных в плату
function TESPLuaProperties.getWriteDelay: integer;
begin
  Result := 60;
end;


// Это время ждем ответ от планы
// если ответ не меняется считаем что передача завершена
function TESPLuaProperties.getWaitResultDelay: integer;
begin
  Result := 300;
end;

// После записи в устройство ждем компиляции это время
// если ошибок нет - считаем что запись выполнена успешно
function TESPLuaProperties.getWaitResultDelayCompile: integer;
begin
  Result := 1000;
end;

// Таймаут ожидания ответа от платы при ожидании символа
function TESPLuaProperties.getWaitLineDelay: integer;
begin
  Result := 5000;
end;

// время ожидания при подключении к плате для выпроботки RTS сигнала
function TESPLuaProperties.getOpenRTSDelay: integer;
begin
  Result := 300;
end;




constructor TESPLuaProperties.Create;
begin

end;

destructor TESPLuaProperties.Destroy;
begin
  inherited Destroy;
end;

end.

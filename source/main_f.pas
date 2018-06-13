unit main_f;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, CPortCtl, CPort, Forms, Controls, Graphics,
  Dialogs, StdCtrls, Crt, espluaaction;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ComDataPacket1: TComDataPacket;
    ComPort1: TComPort;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ComDataPacket1Packet(Sender: TObject; const Str: string);
    procedure ComPort1RxBuf(Sender: TObject; const Buffer; Count: integer);
    procedure ComPort1RxChar(Sender: TObject; Count: integer);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  comport1.Open;
  comport1.SetRTS(True);
  delay(500);
  comport1.SetRTS(False);
  delay(5000);
  comport1.WriteStr('if file.open("init.lua") then   print(file.read())   file.close() end' + #13#10);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  espaction: tespluaaction;
  r: rResult;
begin
  espaction := tespluaaction.Create(self, 'COM6', 9600);
  // r := espaction.Open;

  r := espaction.getFileList();
  memo1.Lines.Add(IntToStr(r.RES) + ' ' + r.MSG);
  memo1.Lines.Add(espaction.getReadStr);
  memo1.Lines.Add('-------');

  r := espaction.getFile('init.lua');
  memo1.Lines.Add(IntToStr(r.RES) + ' ' + r.MSG);
  memo1.Lines.Add(espaction.getReadStr);
  memo1.Lines.Add('-------');

 { r := espaction.getFile('script1.lua');
  memo1.Lines.Add(IntToStr(r.RES) + ' ' + r.MSG);
  memo1.Lines.Add(espaction.getReadStr);
  memo1.Lines.Add('-------');
  }


  FreeAndNil(espaction);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  espaction: tespluaaction;
  r: rResult;
begin
  espaction := tespluaaction.Create(self, 'COM6', 9600);
  // r := espaction.Open;

  r := espaction.WriteFile('init.lua', memo2.Lines.Text);
  memo1.Lines.Add(IntToStr(r.RES) + ' ' + r.MSG);
  memo1.Lines.Add(espaction.getReadStr);
  memo1.Lines.Add('-------');




  FreeAndNil(espaction);
end;


procedure TForm1.ComDataPacket1Packet(Sender: TObject; const Str: string);
begin
  memo1.Lines.Add(str);
end;

procedure TForm1.ComPort1RxBuf(Sender: TObject; const Buffer; Count: integer);
begin

end;

procedure TForm1.ComPort1RxChar(Sender: TObject; Count: integer);
begin

end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if comport1.Connected then
    comport1.Close;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

end.

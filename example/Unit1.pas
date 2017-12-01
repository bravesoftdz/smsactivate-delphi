unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, SmSActivate;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Button1: TButton;
    Edit2: TEdit;
    Button2: TButton;
    Edit3: TEdit;
    Button3: TButton;
    RadioButton3: TRadioButton;
    Button4: TButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    Edit4: TEdit;
    Button5: TButton;
    procedure FormCreate(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure RadioButton7Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  sms: TSMSActivate;
  status: string;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  ShowMessage(sms.getBalance);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ShowMessage(sms.getNumbersStatus(Edit2.Text));
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if sms.getNumbersStatus(Edit3.Text).ToInteger > 0 then
  begin
    sms.getNumber(Edit3.Text);
  end
  else
  begin
    ShowMessage('Нет свободных номеров');
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if sms.setStatus(status, sms.Id) <> true then
  begin
    ShowMessage('ERROR');
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  if sms.getStatus(sms.Id) then
  begin
    Edit4.Text := sms.Code;
  end
  else
  begin
    ShowMessage('ERROR');
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  sms := TSMSActivate.Create(Edit1.Text);
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  sms.Country := '0';
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
  sms.Country := '1';
end;

procedure TForm1.RadioButton3Click(Sender: TObject);
begin
  status := '-1';
end;

procedure TForm1.RadioButton4Click(Sender: TObject);
begin
  status := '1';
end;

procedure TForm1.RadioButton5Click(Sender: TObject);
begin
  status := '3';
end;

procedure TForm1.RadioButton6Click(Sender: TObject);
begin
  status := '6';
end;

procedure TForm1.RadioButton7Click(Sender: TObject);
begin
  status := '8';
end;

end.

unit SmSActivate;

interface

uses
  System.SysUtils, System.Classes, HTTPSend, ssl_openssl;

const
  URL = 'http://sms-activate.ru/stubs/handler_api.php?';
  RUS = '0';
  UKR = '1';

type
  TLogEvent = procedure(txt: string) of object;

  TSMSActivate = class
  private
    FOnLog: TLogEvent;
    FId, FBalance, FNumber, FCode: string;
    Fkey, FCountry: string;
    HTTP: THTTPSend;
    FHTML: TStringList;
    function Pars(Str, s1, s2: string): string;
    function HTTPGet(URL: string): string;
  protected
  public
    function getBalance: string; // узнать баланс
    function getNumbersStatus(service: string): string; // запрос на сводобные номера
    function getNumber(service: string): Boolean; // заказать номер
    function setStatus(status, Id: string): Boolean; // изменения статуса активации
    function getStatus(Id: string): Boolean; // получить состояния активации

    constructor Create(key: string);
    destructor Destroy;

    property Balance: string read FBalance write FBalance;
    property Id: string read FId write FId;
    property Number: string read FNumber write FNumber;
    property Code: string read FCode write FCode;
    property Country: string read FCountry write FCountry;

    property OnLog: TLogEvent read FOnLog write FOnLog;
  end;

implementation

{ TSMSActivate }

constructor TSMSActivate.Create(key: string);
begin
  Self.Fkey := trim(key);
  FHTML := TStringList.Create;
  HTTP := THTTPSend.Create;
  HTTP.AddPortNumberToHost := false;
  HTTP.UserAgent := 'Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20100101 Firefox/14.0.1';
  HTTP.Protocol := '1.1';
  HTTP.Timeout := 10000;
end;

destructor TSMSActivate.Destroy;
begin
  try
    setStatus('6', FId);
  finally
    FHTML.Free;
    HTTP.Free;
  end;
end;

function TSMSActivate.getBalance: string; // узнать баланс
var
  Str: array of string;
begin
  HTTPGet(URL + 'api_key=' + Fkey + '&action=getBalance');
  if Pos('ACCESS_BALANCE', FHTML.Text) <> 0 then
  begin
    FBalance := Pars(FHTML.Text, 'ACCESS_BALANCE:', #13);
    Result := FBalance;
  end
  else
  begin
    Result := 'ERROR';
  end;
end;

function TSMSActivate.getNumbersStatus(service: string): string; // запрос на сводобные номера
begin
  HTTPGet(URL + 'api_key=' + Fkey + '&action=getNumbersStatus&country=' + FCountry);
  if Pos('vk', FHTML.Text) <> 0 then
  begin
    Result := Pars(FHTML.Text, trim(service) + '_0":"', '",');
  end
  else
  begin
    Result := '0';
  end;
end;

function TSMSActivate.getNumber(service: string): Boolean;
begin
  HTTPGet(URL + 'api_key=' + Fkey + '&action=getNumber&service=' + trim(service) + '&ref=instacash&country=' +
    FCountry);
  if Pos('ACCESS_NUMBER', FHTML.Text) <> 0 then
  begin
    FId := trim(Pars(FHTML.Text, 'ACCESS_NUMBER:', ':'));
    FNumber := trim(Pars(FHTML.Text + '@', Id + ':', '@'));
    Result := True;
  end
  else
  begin
    Result := false;
  end;
end;

function TSMSActivate.getStatus(Id: string): Boolean;
var
  Count: integer;
begin
  Count := 0;
  FCode := '';
  repeat
    inc(Count);
    HTTPGet(URL + 'api_key=' + Fkey + '&action=getStatus&id=' + Id);
    if Pos('STATUS_OK', FHTML.Text) <> 0 then
    begin
      FCode := trim(Pars(FHTML.Text + '@', 'STATUS_OK:', '@'));
      Result := True;
      Break;
    end;
    Sleep(1000);
  until (trim(FHTML.Text) = 'STATUS_OK') or (Count = 15) and (HTTP.ResultCode = 200);
end;

function TSMSActivate.setStatus(status, Id: string): Boolean;
begin
  HTTPGet(URL + 'api_key=' + Fkey + '&action=setStatus&status=' + status + '&id=' + Id);
  if Pos('ACCESS', FHTML.Text) <> 0 then
  begin
    Result := True;
  end
  else
  begin
    Result := false;
  end;
end;

function TSMSActivate.HTTPGet(URL: string): string;
var
  rez: TStringList;
begin
  repeat
    FHTML.Clear;
    HTTP.Document.Clear;
    HTTP.Headers.Clear;
    HTTP.HTTPMethod('GET', trim(URL));
    rez := TStringList.Create;
    rez.LoadFromStream(HTTP.Document);
    Result := rez.Text;
    FHTML.Text := rez.Text;
    rez.Free;
    if Assigned(FOnLog) then
      FOnLog(IntToStr(HTTP.ResultCode) + ' GET :' + URL + ' RESPONS : ' + trim(FHTML.Text));
    Sleep(500);
  until HTTP.ResultCode = 200;
end;

function TSMSActivate.Pars(Str, s1, s2: string): string;
begin
  Result := '';
  if (s1 > '') and (Pos(s1, Str) <> 0) then
  begin
    Delete(Str, 1, Pos(s1, Str) + Length(s1) - 1);
    Result := Str;
  end;
  if (s2 > '') and (Pos(s2, Str) <> 0) then
  begin
    Result := Copy(Str, 1, Pos(s2, Str) - 1);
  end;
end;

end.

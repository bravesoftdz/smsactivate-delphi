# smsactivate-delphi
library for working with the site sms-activate.ru delphi

sms := TSMSActivate.Create(KEY)

sms.getBalance - запрос баланса

sms.getNumbersStatus(SERVICE) - запрос количества доступных номеров

sms.getNumber(SERVICE) - заказ номера
sms.setStatus(STATUS, sms.Id) - изменение статуса активации
sms.getStatus(sms.Id) - получить состояние активации
полученый код хранится в sms.Code

﻿# Отправка сообщений используя разные транспорты

[![GitHub release](https://img.shields.io/github/release/oscript-library/messenger.svg)](https://github.com/oscript-library/messenger)

## Введение

## Установка
Для использования необходимо выполнить инициализацию параметров транспорта, используя соответствующий метод класса и параметры авторизации (см. ниже).

## Использование

### Для Slack
Необходимо зарегистрировать бота, получить его токен авторизации и дать доступ в необходимые каналы.
Описание API https://api.slack.com/bot-users.
Перед отправкой сообщений необходимо у созданного объекта вызвать метод 'ИнициализацияSLACK' куда передать данные авторизации.

### Для SMS
На данный момент поддерживается отправка сообщений через операторов SMS-Bliss, Infobip и sms4b. 
Для использования необходимо заключить договор с соответствующим оператором.
 - SMS-Bliss: https://smsbliss.ru/
 - Infobip: http://www.infobip.com.ru/
 - sms4b: https://www.sms4b.ru/

Перед отправкой сообщений необходимо у созданного объекта вызвать метод 'ИнициализацияSMS' куда передать код оператора "SMSBliss" ,"infobip" или "sms4b" и данные авторизации.

### Для Gitter
Необходимо получить токен авторизации https://developer.gitter.im/apps  
Имя комнаты указывается полностью ИмяОрганизации/ИмяРепозитория  
например для `https://gitter.im/asosnoviy/Lobby` имя комнаты `asosnoviy/Lobby`  
Перед отправкой сообщений необходимо у созданного объекта вызвать метод 'ИнициализацияGitter' куда передать токен.

####№ Пример:
```
    ИмяКомнаты = "organization/repo";  
    Мессенджер = Новый Мессенджер(); 
    Мессенджер.ИнициализацияGitter(ТокенПользователя);
    Мессенджер.ОтправитьСообщение(Мессенджер.ДоступныеПротоколы().gitter, ИмяКомнаты, "Всем привет!" );
```


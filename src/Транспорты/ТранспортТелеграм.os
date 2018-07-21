﻿
///////////////////////////////////////////////////////////////////////////////////////////////
//
// Модуль транспорта отправки сообщений telegram
//
///////////////////////////////////////////////////////////////////////////////////////////////

Перем ПараметрыАвторизации;	// хранит структуру авторизации
Перем ОписаниеПротокола;	// хранит структуру описания протокола

///////////////////////////////////////////////////////////////////////////////////////////////
// Стандартный интерфейс
///////////////////////////////////////////////////////////////////////////////////////////////

// Протокол
//	Метод возвращает описание используемого протокола
//
// Возвращаемое значение:
//	Структура - Описание протокола
//		{
//			Имя 			- Строка - Системное имя транспорта
//			Представление 	- Строка - пользовательское представление транспорта
//			Описание		- Строка - Строковое описание транспорта
//			Операторы		- Структура - Возможные операторы транспорта
//		}
//
Функция Протокол() Экспорт
	
	Если ОписаниеПротокола = Неопределено Тогда
		
		ОписаниеПротокола = Новый Структура("Имя, Представление, Описание, Операторы", "telegram", "telegram", "Отправка сообщений в каналы telegram", Неопределено);
		
	КонецЕсли;
	
	Возврат ОписаниеПротокола;
	
КонецФункции // Протокол()

// Инициализация
//	Инициализация параметров транспорта
//
// Параметры:
//  ПараметрыИнициализации - Структура - набор параметров инициализации
//
Процедура Инициализация(ПараметрыИнициализации) Экспорт
	
	Если ПараметрыИнициализации = Неопределено Тогда
		
		Сообщить(СтрШаблон("Для инициализации транспорта %1 необходимо передавать в параметрах: ", Протокол().Представление));
		Сообщить(" - Логин");
		
		ВызватьИсключение СтрШаблон("Инициализация транспорта %1 невыполнена", Протокол().Представление);
		
	КонецЕсли;
	
	ПараметрыАвторизации = Новый Структура("Токен", ПараметрыИнициализации.Логин);
	
КонецПроцедуры // Инициализация()

// ОтправитьСообщение
//	Метод отправки сообщения
//
// Параметры:
//	Адресат					- Строка	- Адресат сообщения
//	Сообщение				- Строка	- Текст отправляемого сообщения
//	ДополнительныеПараметры	- Структура	- Набор дополнительных параметров
//
Процедура ОтправитьСообщение(Адресат, Сообщение, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ПараметрыАвторизации = Неопределено Тогда
		
		ВызватьИсключение СтрШаблон("Для отправки сообщения необходимо выполнить инициализацию транспорта %1", Протокол().Представление);
		
	КонецЕсли;
	
	ТекстСообщения = СтрЗаменить(Сообщение, Символы.ПС, "%0A");
	ПараметрыСообщения = Новый Структура("chat_id, text", Адресат, ТекстСообщения);

	ОпределитьТипСообщения(ДополнительныеПараметры, ПараметрыСообщения);

	ОтветHTTP = ВызватьМетодTelegramAPI("sendMessage", ПараметрыСообщения);
	
	
КонецПроцедуры // ОтправитьСообщение()

///////////////////////////////////////////////////////////////////////////////////////////////
// Методы реализации
///////////////////////////////////////////////////////////////////////////////////////////////

Функция ВызватьМетодTelegramAPI(ИмяМетода, Параметры) Экспорт
	
	СтрокаПараметров = "";
	Для Каждого Параметр Из Параметры Цикл
		
		Шаблон = "%1=%2&";
		СтрокаПараметров = СтрокаПараметров + СтрШаблон(Шаблон, Параметр.Ключ, Параметр.Значение);
		
	КонецЦикла;	
	
	ИмяСервера = "https://api.telegram.org";
	
	URL = "/bot"
	+ ПараметрыАвторизации.Токен
	+ "/" + ИмяМетода
	+ "?" + СтрокаПараметров;
	
	HTTPЗапрос = Новый HTTPЗапрос(URL);
	
	HTTP = Новый HTTPСоединение(ИмяСервера);
	ОтветHTTP = HTTP.ОтправитьДляОбработки(HTTPЗапрос);
	
	Возврат ОтветHTTP;
	
КонецФункции

Процедура ОпределитьТипСообщения(ДополнительныеПараметры, ПараметрыСообщения)
	Если ДополнительныеПараметры <> Неопределено 
		И
		ДополнительныеПараметры.Свойство("ТипСообщения") Тогда
		ТипСообщения = НРег(ДополнительныеПараметры.Свойство("ТипСообщения"));
		Если ТипСообщения = "html" Тогда
			ПараметрыСообщения.Вставить("parse_mode", "html");
		ИначеЕсли ТипСообщения = "markdown" или ТипСообщения = "md" Тогда
			ПараметрыСообщения.Вставить("parse_mode", "Markdown");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////

ПараметрыАвторизации = Неопределено;

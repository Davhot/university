# README

## Формат POST - запроса для отправки лога на [url]/main_hot_catch_logs
* log_data - данные лога
* name_app - название приложения, из которого отправляется лог
* from_log - из какой части приложения прибыл лог
Значения: [Rails|Client|Puma|Nginx]
* status   - статус HTTP запроса

Гем, предоставляющий возможность отправки логов в главное приложение:
`gem hot_catch`

Пример запроса:
`{main_hot_catch_logs: {
  "log_data":"some message",
  "name_app":"diploma_app",
  "from_log":"Rails",
  "status":"500"}
}`

### Версия GoAccess - 1.2.

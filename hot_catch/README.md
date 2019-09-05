# HotCatch
Данный гем позволяет посылать лог-данные на главный сервер.

## Установка
1. Добавить гем в `Gemfile`
```ruby
gem 'hot_catch'
```
2. `$ bundle install`
3. Запустить генератор установки: `$ rails generate hot_catch:install`
Для удаления: `$ rails generate hot_catch:uninstall`
4. Изменить в `config/hot_catch_config.json` url - адрес сервера для отправки лог файлов.
Автоматически запросы посылаются на адрес *url/main_hot_catch_logs*, но нужно указать только *url*.
5. Запустить sidekiq
`bundle exec sidekiq`

Это всё! Теперь логи автоматически посылаются на сервер.

## Примечание
Ответы от сервера, куда отправляются логи, доступен в файле `log/hot_catch_log_response_errors`.
Если всё порядке - этого файла нет или он пуст.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

# ESPLuaTool
Программа для заливки LUA скриптов NodeMCU (https://en.wikipedia.org/wiki/NodeMCU) в микроконтроллер ESP8622 из командной строки. 

Разработана на FreePascal, IDE Lazarus (https://www.lazarus-ide.org/index.php?page=downloads).

Для компиляции и сборки требуется компонент Cportlaz_v1.0.0 (https://sourceforge.net/projects/cportlaz/). В случае возникновения ошибок компиляции в компоненте при установке в IDE - строки с ошибками необходимо закомментировать (изменить) по смыслу.

Разработано специально для использования совместно с notepad++ в качестве дополнения.

Для подключения к notepad++ воспользуйтесь следующей инструкцией:
- Скачайте последнюю версию notepad++ (https://notepad-plus-plus.org/download/).
- Скачайте дополнение NppExec к notepad++ (https://sourceforge.net/projects/npp-plugins/files/NppExec/).
- Установите дополнене NppExec, распаковав содержимое архива в папку "plugins" notepad++.
- Скачайте последнюю версию ESPLuaTool (https://github.com/MatrexAl/espluatool/archive/master.zip).
- Распакуйте ESPLuaTool в любую директорию.
- Запустите notepad++, запустите "Плагины -> NppExec -> Execute" (или нажмите F6).
- В открывшемся окне введите стоку запуска для прошивки микроконтроллера "d:\Lazarus\!project\espluatool\bin\espluatool.exe -p COM6 -b 9600 -wd $(FULL_CURRENT_PATH)" (без кавычек). Нажмите кнопку "Save..." и введите имя скрипта для сохранения, например "LUA Запись и компиляция". Подтвердите сохранение.
- Для запуска скрипта в notepad++ запустите "Плагины -> NppExec -> Execute" (или нажмите F6), выберите нужный скрипт, нажмите "Ок".

Некоторые переменные среды notepad++ если вы редактируете, например, файл "E:\my Web\main\welcome.html":
- $(FULL_CURRENT_PATH) — "E:\my Web\main\welcome.html"
- $(CURRENT_DIRECTORY) — "E:\my Web\main\"
- $(FILE_NAME) — "welcome.html"
- $(NAME_PART) — "welcome"
- $(EXT_PART) — "html"
- $(SYS.<переменная>) — имя системной переменной окружения, например, $(SYS.PATH).

Ключи командной строки приложения ESPLuaTool (вводятся без кавычек):
- "-с" проверка скрипта после загрузки в микроконтроллер
- "-p COMx" назначение порта к которому подключен микроконтроллер
- "-b xxxxx" назначение скорости обмена данными
- "-w filepath" загрузка скрипта в микроконтроллер
- "-wd filepath" загрузка скрипта в микроконтроллер, компиляция и запуск
- "-ga dir" сохранение в указанную директорию всех файлов скриптов микроконтроллера
- "-g dir -f file" сохранение в указанную директорию файла скрипта микроконтроллера
- "-d filename" выполнить файл
- "-v filepath" сохранить в файл состояние переменных

Примеры командной строки:
- для прошивки микроконтроллера: espluatool.exe -c -p COM6 -b 9600 -w c:\init.lua
- для прошивки микроконтроллера, компиляции и запуска: espluatool.exe -c -p COM6 -b 9600 -wd c:\init.lua 
- получить содержимое всех файлов и положить их в каталог: espluatool.exe -p COM6 -b 9600 -ga c:\
- получить содержимое фала и положить его в каталог: espluatool.exe -p COM6 -b 9600 -g c:\ -f init.lua




01.07.2018 Головейко Александр, Брест, Беларусь

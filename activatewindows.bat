@echo off
chcp 65001 > nul
echo Проверка прав администратора...
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Извините, но для запуска этой программы требуются права администратора.
    pause
    exit /b
)
:: Проверка версии и редакции Windows
systeminfo | findstr /C:"OS Name" > nul
if %errorlevel% equ 0 (
    set edition=Unknown
    for /f "tokens=2 delims=:" %%i in ('systeminfo ^| findstr /C:"OS Name"') do (
        set os_name=%%i
        echo %os_name% | findstr /C:"Windows 10" > nul
        if %errorlevel% equ 0 (
            set edition=Home
            echo %os_name% | findstr /C:"Professional" > nul
            if %errorlevel% equ 0 (
                set edition=Professional
            )
        )
        echo %os_name% | findstr /C:"Windows 11" > nul
        if %errorlevel% equ 0 (
            set edition=Home
            echo %os_name% | findstr /C:"Professional" > nul
            if %errorlevel% equ 0 (
                set edition=Professional
            )
        )
    )
)

:: Проверка редакции и версии Windows
if "%edition%"=="Unknown" (
    echo Ваша версия Windows не поддерживается.
    echo Эта программа работает только на Windows 10 или 11 Professional или Home.
    pause
    exit /b
)

:main_menu
cls
echo Выберите действие:
echo 1. Активация Windows (%edition%)
echo 2. Инструменты
echo 3. Справка
echo 4. Выход

set /p choice="Выбор (1-4): "
if "%choice%"=="1" goto activate_windows
if "%choice%"=="2" goto tools_menu
if "%choice%"=="3" goto help_menu
if "%choice%"=="4" goto exit

:activate_windows
cls
if "%edition%"=="Home" (
    echo Активация Windows Home.
    slmgr /ipk TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
slmgr /skms kms.digiboy.ir
slmgr /ato
echo Готово! Зайди в настройки или инструменты чтобы проверить активацию
echo Подпишись на телеграмм канал автора https://t.me/@memscholp
set /p view_license="Желаете просмотреть информацию о лицензии? (y/n): "
if /i "%view_license%"=="y" (
    goto check_activation_extended
) else (
    goto main_menu
)
pause
goto main_menu
) else (
echo Активация windows pro
slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
slmgr /skms kms.digiboy.ir
slmgr /ato
echo Готово! Зайди в настройки или инструменты чтобы проверить активацию
echo Подпишись на телеграмм канал автора https://t.me/@memscholp
set /p view_license="Желаете просмотреть информацию о лицензии? (y/n): "
if /i "%view_license%"=="y" (
    goto check_activation_extended
) else (
    goto main_menu
)
)
pause
goto main_menu

:tools_menu
cls
echo Подменю "Инструменты":
echo 1. Удаление активации windows 
echo 2. Расширенная информация об активации вашей windows
echo 3. Вернуться в главное меню

set /p tool_choice="Выбор инструмента (1-3): "
if "%tool_choice%"=="1" goto tool1
if "%tool_choice%"=="2" goto check_activation_extended
if "%tool_choice%"=="3" goto main_menu

:tool1
echo Идет удаление вашей активации windows 
slmgr /upk
slmgr /cpky
slmgr /rearm
:confirm_reboot
set /p confirm_reboot="Чтобы активировать виндовс после удаления активации необходима перезагрузка компьютера. Вы хотите перезагрузить компьютер сейчас? (y/n): "
if /i "%confirm_reboot%"=="y" (
    shutdown /r /t 0
) else if /i "%confirm_reboot%"=="n" (
    goto main_menu
) else (
    echo Пожалуйста, введите y или n.
    goto confirm_reboot
)
pause
goto tools_menu

:check_activation_extended
cls
echo Расширенная проверка статуса активации Windows...

:: Установка кодировки UTF-8 для корректного отображения русского текста
chcp 866 > nul

:: Проверка активации с помощью slmgr.vbs
cscript //nologo c:\windows\system32\slmgr.vbs /dlv > activation_status_extended.txt

:: Отображение содержимого файла activation_status_extended.txt
type activation_status_extended.txt

del activation_status_extended.txt
chcp 65001 > nul
pause
goto tools_menu



:help_menu
cls
echo Подменю "Справка":
echo 1. О программе
echo 2. Как пользоваться
echo 3. Часто задаваемые вопросы
echo 4. Вернуться в главное меню

set /p help_choice="Выбор пункта (1-4): "
if "%help_choice%"=="1" goto about_program
if "%help_choice%"=="2" goto how_to_use
if "%help_choice%"=="3" goto faq
if "%help_choice%"=="4" goto main_menu

:about_program
echo Информация о программе.
echo Активатор windows от memschol v1.5
echo [Телеграмм канал автора](https://t.me/memscholp)
pause
goto help_menu

:how_to_use
echo Как пользоваться программой.
echo Программа для активации windows легко активирует вашу windows в один клик! Программа сама определит вашу редакцию и версию вашей системы!
pause
goto help_menu

:faq
echo Часто задаваемые вопросы.
echo Что делать если не удалось активировать?
echo попробуйте в инструментах сделать полное удаление лицензии, а затем перезагрузить ваш компьютер и снова попробовать активировать
echo Также может быть проблема с kms-сервером попробуйте включить vpn а затем снова попытаться активировать
echo Я нашел в программе баг
echo Обратитесь в телеграмм канал разработчика и напишите о баге в коментариях
echo Есть ли вирусы?
echo Нет. Проверьте файл через активирус и убедитесь что там нет вирусов
echo Программа использует официальный инструмент от Microsoft. 
pause
goto help_menu

:exit
echo Завершение работы.
pause

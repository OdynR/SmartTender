*** Settings ***
Resource  keywords.robot


*** Keywords ***
Підписати ЕЦП
	Натиснути підписати ЕЦП
	Вибрати тестовий ЦСК
	Завантажити ключ
	Ввести пароль ключа
	Wait Until Keyword Succeeds  3m  10  Натиснути Підписати
	Перевірити успішність підписання

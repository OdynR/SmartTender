*** Settings ***
Resource  ../../src/src.robot
Suite Setup     Відкрити вікна для всіх користувачів
Suite Teardown  Suite Postcondition
Test Setup      Check Prev Test Status
Test Teardown   Run Keyword If Test Failed  Capture Page Screenshot


#  robot --consolecolors on -L TRACE:INFO -d test_output -i create_tender suites/get_auction_href/test_open_eu_get_auction_href.robot
*** Test Cases ***
Створити тендер
	[Tags]  create_tender
	Switch Browser  tender_owner
	Перейти у розділ (webclient)  Публічні закупівлі (тестові)
	Відкрити вікно створення тендеру
  	Вибрати тип процедури  Відкриті торги з публікацією англійською мовою
  	Заповнити endDate періоду пропозицій
  	Заповнити amount для tender
  	Заповнити minimalStep для tender
  	Заповнити title для tender
  	Заповнити title_eng для tender
  	Заповнити description для tender
  	Додати предмет в тендер
    Додати документ до тендара власником (webclient)
    Зберегти чернетку
    Оголосити закупівлю
    Пошук тендеру по title (webclient)  ${data['title']}
    Отримати tender_uaid щойно стореного тендера
    Звебегти дані в файл


If skipped create tender
	[Tags]  get_tender_data
	${json}  Get File  ${OUTPUTDIR}/artifact.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Знайти тендер усіма користувачами
	[Tags]  create_tender  get_tender_data
	[Template]  Знайти тендер користувачем
	tender_owner
	viewer
	provider1
	provider2


Подати заявку на участь в тендері двома учасниками
	[Tags]  create_tender  get_tender_data
	[Template]  Подати пропозицію учасниками
	provider1
	provider2


Підтвердити прекваліфікацію для доступу до аукціону організатором
    [Tags]  create_tender  get_tender_data
    Підтвердити прекваліфікацію учасників


Отримати поcилання на участь в аукціоні для учасників
	[Tags]  create_tender  get_tender_data
	[Template]  Отримати посилання на аукціон учасником
	provider1
	provider2


Неможливість отримати поcилання на участь в аукціоні
	[Tags]  create_tender  get_tender_data
	[Template]  Перевірити можливість отримати посилання на аукціон користувачем
	viewer
	tender_owner



*** Keywords ***
Відкрити вікна для всіх користувачів
    Start  Bened  tender_owner
    Set Window Size  1280  1024
    Start  viewer_test  viewer
    Set Window Size  1280  1024
    Start  user1  provider1
    Set Window Size  1280  1024
    Start  user2  provider2
    Set Window Size  1280  1024
    ${data}  Create Dictionary
    Set Global Variable  ${data}


Заповнити endDate періоду пропозицій
    ${date}  get_time_now_with_deviation  40  minutes
    ${value}  Create Dictionary  endDate=${date}
    Set To Dictionary  ${data}  tenderPeriod  ${value}
    Заповнити текстове поле  //*[@data-name="D_SROK"]//input     ${date}


Заповнити contact для tender
    ${input}  Set Variable  //*[@data-name="N_KDK_M"]//input[not(contains(@type,'hidden'))]
    ${selector}  Set Variable  //*[text()="Прізвище"]/ancestor::div[4]//div[@class="dhxcombo_option_text"]/div[1]/div[@class="dhxcombo_cell_text"]
    ${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
    ${value}  Create Dictionary  name=${name}
    ${contactPoint}  Create Dictionary  contactPerson=${value}
    Set To Dictionary  ${data}  procuringEntity  ${contactPoint}


Заповнити amount для tender
    ${amount}  random_number  100000  100000000
    ${value}  Create Dictionary  amount=${amount}
    Set To Dictionary  ${data}  value  ${value}
    Заповнити текстове поле  xpath=//*[@data-name="INITAMOUNT"]//input   ${amount}


Заповнити minimalStep для tender
    ${minimal_step_percent}  random_number  1  5
    ${value}  Create Dictionary  percent=${minimal_step_percent}
    Set To Dictionary  ${data.value}  minimalStep  ${value}
    Заповнити текстове поле  xpath=//*[@data-name="MINSTEP_PERCENT"]//input   ${minimal_step_percent}


Заповнити title для tender
    ${text}  create_sentence  5
    ${title}  Set Variable  [ТЕСТУВАННЯ] ${text}
    Set To Dictionary  ${data}  title  ${title}
    Заповнити текстове поле  xpath=//*[@data-name="TITLE"]//input   ${title}


Заповнити title_eng для tender
    ${text_en}  create_sentence  5
    ${title_en}  Set Variable  [ТЕСТУВАННЯ] ${text_en}
    Set To Dictionary  ${data}  title_en  ${title_en}
    Заповнити текстове поле  xpath=//*[@data-name="TITLE_EN"]//input   ${title_en}


Заповнити description для tender
    ${description}  create_sentence  15
    Set To Dictionary  ${data}  description  ${description}
    Заповнити текстове поле  xpath=//*[@data-name="DESCRIPT"]//textarea  ${description}


Додати предмет в тендер
    Заповнити description для item
    Заповнити description_eng для item
    Заповнити quantity для item
    Заповнити id для item
    Заповнити unit.name для item
    Заповнити postalCode для item
    Заповнити streetAddress для item
    Заповнити locality для item
    Заповнити endDate для item
    Заповнити startDate для item


Заповнити description для item
    ${description}  create_sentence  5
    ${value}  Create Dictionary  description=${description}
    Set To Dictionary  ${data}  item  ${value}
    Заповнити текстове поле  xpath=(//*[@data-name='KMAT']//input)[1]  ${description}


Заповнити description_eng для item
    ${description_en}  create_sentence  5
    ${value}  Create Dictionary  description_en=${description_en}
    Set To Dictionary  ${data}  item  ${value}
    Заповнити текстове поле  xpath=//*[@data-name="RESOURSENAME_EN"]//input[1]  ${description_en}


Заповнити quantity для item
    ${quantity}  random_number  1  1000
    Set To Dictionary  ${data['item']}  quantity  ${quantity}
    Заповнити текстове поле  xpath=//*[@data-name='QUANTITY']//input  ${quantity}


Заповнити id для item
    ${input}  Set Variable  //*[@data-name='MAINCLASSIFICATION']//input[not(contains(@type,'hidden'))]
    ${selector}  Set Variable  //*[text()="Код класифікації"]/ancestor::div[4]//div[@class="dhxcombo_option_text"]/div[1]/div[@class="dhxcombo_cell_text"]
    ${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
    Set To Dictionary  ${data['item']}  id  ${name}


Заповнити unit.name для item
    ${input}  Set Variable  //*[@data-name='EDI']//input[not(contains(@type,'hidden'))]
    ${selector}  Set Variable  //*[text()="ОВ. Найменування"]/ancestor::div[4]//div[@class="dhxcombo_option_text"]/div[1]/div[@class="dhxcombo_cell_text"]
    ${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
    Set To Dictionary  ${data['item']}  unit  ${name}


Заповнити postalCode для item
    ${postal code}  random_number  10000  99999
    Заповнити текстове поле  xpath=//*[@data-name='POSTALCODE']//input  ${postal code}
    Set To Dictionary  ${data['item']}  postal code  ${postal code}


Заповнити streetAddress для item
    ${address}  create_sentence  1
    ${address}  Set Variable  ${address[:-1]}
    Заповнити текстове поле  xpath=//*[@data-name='STREETADDR']//input  ${address}
    Set To Dictionary  ${data['item']}  streetAddress  ${address}


Заповнити locality для item
    ${input}  Set Variable  //*[@data-name='CITY_KOD']//input[not(contains(@type,'hidden'))]
    ${selector}  Set Variable  //*[text()="Місто"]/ancestor::div[4]//div[@class="dhxcombo_option_text"]/div[1]/div[@class="dhxcombo_cell_text"]
    ${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
    Set To Dictionary  ${data['item']}  city  ${name}


Заповнити endDate для item
    ${value}  get_time_now_with_deviation  2  days
    Заповнити текстове поле  xpath=//*[@data-name="DDATETO"]//input  ${value}


Заповнити startDate для item
    ${value}  get_time_now_with_deviation  1  days
    Заповнити текстове поле  xpath=//*[@data-name="DDATEFROM"]//input  ${value}


Дочекатись дати початку періоду прийому пропозицій
    Дочекатись дати  ${data['tenderPeriod']['startDate']}
    wait until keyword succeeds  20m  30s  Перевірити статус тендера  Прийом пропозицій


Дочекатись дати закінчення періоду прийому пропозицій
    Дочекатись дати  ${data['tenderPeriod']['endDate']}
    wait until keyword succeeds  20m  30s  Перевірити статус тендера  Аукціон


Підтвердити прекваліфікацію учасників
    Switch Browser  tender_owner
    Go To  https://smarttender.biz/webclient/
	Дочекатись закінчення загрузки сторінки(webclient)
	Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    Пошук тендеру по title (webclient)  ${data['title']}
    Натиснути кнопку Перечитать (Shift+F4)
    Wait Until Element Is Visible  //*[@data-placeid="CRITERIA"]//td[text()="Преквалификация"]
    ${count}  Get Element Count  //*[@title="Участник"]/ancestor::div[3]//tr[contains(@class,"Row")]//td[@class and @title][1]
    :FOR  ${i}  IN RANGE  1  ${count}+1
    \  Надати рішення про допуск до аукціону учасника  ${i}


Надати рішення про допуск до аукціону учасника
    [Arguments]  ${i}
    ${selector}  Set Variable  (//*[@title="Участник"]/ancestor::div[3]//tr[contains(@class,"Row")]//td[@class and @title][1])[${i}]
    Click Element  ${selector}
    Sleep  .5
    Натиснути кнопку Просмотр (F4)
    Дочекатись закінчення загрузки сторінки(webclient)
    Page Should Contain  Отправить решение
    Click Element  //*[@title="Допустить участника к аукциону"]
    Sleep  .5
    Click Element  (//*[@data-type="CheckBox"]//td/span)[1]
    Click Element  (//*[@data-type="CheckBox"]//td/span)[2]
    Sleep  .5
    Click Element  //*[@title="Отправить решение"]
    Погодитись з рішенням прекваліфікації
    Відмовитись від накладання ЕЦП на кваліфікацію


Погодитись з рішенням прекваліфікації
    ${status}  Run Keyword And Return Status  Wait Until Page Contains  Вы уверены в своем решении?
    Run Keyword If  '${status}' == 'True'  Run Keywords
    ...  Click Element  xpath=//*[@id="IMMessageBoxBtnYes_CD"]
    ...  AND  Дочекатись закінчення загрузки сторінки(webclient)


Відмовитись від накладання ЕЦП на кваліфікацію
    ${status}  Run Keyword And Return Status  Wait Until Page Contains  Наложить ЭЦП на квалификацию?
    Run Keyword If  '${status}' == 'True'  Run Keywords
    ...  Click Element  xpath=//*[@id="IMMessageBoxBtnNo_CD"]
    ...  AND  Дочекатись закінчення загрузки сторінки(webclient)
*** Keywords ***
Підтвердити повідомлення про умови проведення аукціону
    ${status}  Run Keyword And Return Status  Wait Until Page Contains  Чи погоджуєтесь Ви з умовами проведення аукціону?
    Run Keyword If  '${status}' == 'True'  Run Keywords
    ...  Click Element  xpath=//button[@class="btn btn-success"]
    ...  AND  Wait Until Element Is Not Visible  xpath=//button[@class="btn btn-success"]


Натиснути кнопку "До аукціону"
    Reload Page
	Wait Until Element Is Visible  //*[@data-qa="button-poptip-participate-view"]  30
	Click Element  //*[@data-qa="button-poptip-participate-view"]
	Дочекатись отримання посилань на аукціон


Натиснути кнопку "Додати документи"
    Reload Page
    ${selector}  Set Variable  //a[contains(@class, "btn-success") and contains(text(), "Додати документи")]
#    Wait Until Page Contains Element  ${selector}
#    Scroll Page To Element XPATH  ${selector}
    Wait Until Element Is Visible  ${selector}
    Click Element  ${selector}


Натиснути кнопку "Підтвердити пропозицію"
    Wait Until Element Is Visible  //span[contains(text(), "Підтвердити пропозицію")]
    Click Element  //span[contains(text(), "Підтвердити пропозицію")]
    Дочекатись закінчення загрузки сторінки
    Wait Until Element Is Visible  //span[contains(text(), "Так")]
    Click Element  //span[contains(text(), "Так")]
    Дочекатись закінчення загрузки сторінки
    Wait Until Element Is Visible  //a[contains(text(), "Перейти")]
    Open Button  //a[contains(text(), "Перейти")]


Натиснути кнопку "Перегляд аукціону"
	${selector}  Set Variable  //*[@data-qa="button-poptip-view"]
	Wait Until Element Is Visible  ${selector}
	Click Element  ${selector}
	Дочекатись отримання посилань на аукціон


Дочекатись отримання посилань на аукціон
	${auction loading}  Set Variable  (//*[@class="ivu-load-loop ivu-icon ivu-icon-load-c"])[1]
	Wait Until Page Does Not Contain Element  ${auction loading}  30
	Sleep  1


Отримати URL для участі в аукціоні
	${selector}  Set Variable  //*[@data-qa="link-participate"]
	${auction_href}  Get Element Attribute  ${selector}  href
	${status}  Run Keyword And Return Status  Page Should Contain Element  //*[@data-qa="link-participate" and @disabled="disabled"]
    Run Keyword If  ${status}  Fail  Кнопка взяти участь в аукціоні не активна
	Run Keyword If  '${auction_href}' == 'None'  Отримати URL для участі в аукціоні
	[Return]  ${auction_href}


Отримати URL на перегляд
	${selector}  Set Variable  //*[@data-qa="link-view"]
	${auction loading}  Set Variable  (//*[@class="ivu-load-loop ivu-icon ivu-icon-load-c"])[1]
	Wait Until Page Does Not Contain Element  ${auction loading}  30
	${auction_href}  Wait Until Keyword Succeeds  20  3  Get Element Attribute  ${selector}  href
	Run Keyword If  '${auction_href}' == 'None'  Отримати URL на перегляд
	[Return]  ${auction_href}


Дочекатись початку періоду перкваліфікації
    ${selector}  Set Variable  //*[@data-qa="tendering-period"]//*[@data-qa="date-end"]
    Wait Until Element Is Visible  ${selector}  30
    Sleep  1
    ${tender end date}  Get text  ${selector}
    Дочекатись дати  ${tender end date}
    Дочекатися статусу тендера  Прекваліфікація


Дочекатись закінчення прийому пропозицій
    ${selector}  Set Variable  //*[@data-qa="tendering-period"]//*[@data-qa="date-end"]
    Reload Page
    Wait Until Element Is Visible  ${selector}  30
    Sleep  1
    ${tender end date}  Get text  ${selector}
    Дочекатись дати  ${tender end date}


Дочекатись закінчення періоду прекваліфікації
    ${selector}  Set Variable  //*[@data-qa="prequalification"]//*[@data-qa="date-end"]
    Reload Page
    Wait Until Element Is Visible  ${selector}  30
    Sleep  1
    ${tender end date}  Get text  ${selector}
    Дочекатись дати  ${tender end date}



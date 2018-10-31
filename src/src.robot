*** Settings ***
Library     Selenium2Library
Library     BuiltIn
Library     Collections
Library	    RequestsLibrary
Library     DebugLibrary
Library     OperatingSystem
Library     String
Library     DateTime
Library     service.py
Library     Faker/faker.py
Variables   /home/testadm/users_variables.py
Resource    search.robot
Resource    make_proposal.robot
Resource    participation_request.robot
Resource    login.robot
Resource    loading.robot
Resource    create_tender.robot
Resource    EDS.robot
Resource    synchronization.robot
Resource    email.robot
Resource    webclient_keywords.robot



*** Variables ***
${tab_keybutton}					\\13

                                    ###ІНШІ ДАННІ###
${browser}                          chrome
${file path}                        src/
${role}                             None
${IP}
${test}                             https://test.smarttender.biz
${prod}                             https://smarttender.biz
${grid}
#http://autotest.it.ua:4444/wd/hub

                                    ###ЛОКАТОРИ###
${block}                            //*[@class='ivu-card ivu-card-bordered']
${logout}                           id=LogoutBtn
${error}                            id=loginErrorMsg

${komertsiyni-torgy icon}           //*[@id="main"]//a[2]/img

${link to make proposal button}     css=[class='show-control button-lot']
${iframe open tender}               //div[@class="container"]/iframe
${make proposal button}             //*[@id="tenderPage"]//a[@class='btn button-lot cursor-pointer']
${make proposal button new}         //*[@id="tenderDetail"]//a[@class="show-control button-lot"]
${derzavni zakupku}                 //*[@id="MainMenuTenders"]//ul[1]/li[2]/a
${first element find tender}        //*[@id="tenders"]//tr[1]/td[2]/a
${bread crumbs}                     (//*[@class='ivu-breadcrumb-item-link'])
${bids search}                      //div[contains(text(), 'Пошук')]/..

*** Keywords ***
Suite Postcondition
  Close All Browsers


Start
  [Arguments]  ${user}  ${alies}=alies
  clear_test_output
  ${login}  ${password}  Отримати дані користувача  ${user}
  ${start_page}  Отримати стартову сторінку  ${site}
  Змінити стартову сторінку для IP
  Open Browser  ${start_page}  ${browser}  ${alies}  ${grid}
  Run Keyword If  "${role}" != "viewer"  Login  ${login}  ${password}


Змінити стартову сторінку для IP
  ${start_page}  Run Keyword If  '${IP}' != ''  Set Variable  ${IP}
  ...  ELSE  Set Variable  ${start_page}
  Set Global Variable  ${start_page}


Отримати стартову сторінку
  [Arguments]  ${site}
  ${start_page}  Run Keyword If  "${site}" == "prod"  Set Variable  ${prod}
  ...  ELSE  Set Variable  ${test}
  Set Global Variable  ${start_page}
  [Return]  ${start_page}


Отримати дані користувача
  [Arguments]  ${user}
  ${a}  Create Dictionary  a  ${users_variables}
  ${users_variables}  Set Variable  ${a.a}
  Set Global Variable  ${name}  ${users_variables.${user}.name}
  Set Global Variable  ${role}  ${users_variables.${user}.role}
  Set Global Variable  ${site}  ${users_variables.${user}.site}

  [Return]  ${users_variables.${user}.login}  ${users_variables.${user}.password}


Open button
  [Documentation]   відкривае лінку з локатора у поточному вікні
  [Arguments]  ${selector}  ${ip}=None
  ${href}=  Get Element Attribute  ${selector}  href
  ${href}  Run Keyword If  "${ip}" == "None"  Поправили лінку для IP  ${href}
  ...  ELSE  Set Variable  ${href}
  Go To  ${href}


Поправили лінку для IP
  [Arguments]  ${href}
  ${href}  Run Keyword If  '${IP}' != ''  convert_url  ${href}  ${IP}
  ...  ELSE  Set Variable  ${href}
  [Return]  ${href}


conver dict to json
  [Arguments]  ${dict}
  ${json}  evaluate  json.dumps(${dict})  json
  [Return]  ${json}


conver json to dict
  [Arguments]  ${json}
  ${dict}  Evaluate  json.loads('''${json}''')  json
  [Return]  ${dict}


Створити та додати файл
  [Arguments]  ${selector}
  ${file}  create_fake_doc
  ${path}  Set Variable  ${file[0]}
  ${name}  Set Variable  ${file[1]}
  ${content}  Set Variable  ${file[2]}
  Choose File  ${selector}  ${path}
  [Return]  ${path}  ${name}  ${content}


Test Postcondition
  Log Location
  Run Keyword If Test Failed  Capture Page Screenshot
  Go To  ${start_page}
  Run Keyword If  "${role}" != "viewer" and "${role}" != "Bened"  Перевірити користувача


Перевірити користувача
  ${status}  Run Keyword And Return Status  Wait Until Page Contains  ${name}  10
  Run Keyword If  "${status}" == "False"  Fatal Error  We have lost user


Scroll Page To Element XPATH
  [Arguments]    ${xpath}
  Run Keyword And Ignore Error
  ...  Execute JavaScript  document.evaluate('${xpath.replace("xpath=", "")}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView({behavior: 'auto', block: 'center', inline: 'center'});
  Run Keyword And Ignore Error
  ...  Execute JavaScript  document.evaluate("${xpath.replace('xpath=', '')}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView({behavior: 'auto', block: 'center', inline: 'center'});


Scroll Page To Top
  Execute JavaScript  window.scrollTo(0,0);


Check Prev Test Status
  ${status}  Set Variable  ${PREV TEST STATUS}
  Run Keyword If  '${status}' == 'FAIL'  Fatal Error  Ой, щось пішло не так! Вимушена зупинка тесту.
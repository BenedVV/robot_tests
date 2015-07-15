*** Setting ***
Library  Selenium2Screenshots
Library  String
Library  DateTime
Library  op_robot_tests.tests_files.etender_service

*** Variables ***
${locator.tenderId}                  jquery=h3
${locator.title}                     jquery=tender-subject-info>div.row:contains("Назва закупівлі:")>:eq(1)>
${locator.description}               jquery=tender-subject-info>div.row:contains("Детальний опис закупівлі:")>:eq(1)>
${locator.minimalStep.amount}        jquery=tender-subject-info>div.row:contains("Мінімальний крок аукціону, грн.:")>:eq(1)>
${locator.procuringEntity.name}      jquery=customer-info>div.row:contains("Найменування:")>:eq(1)>
${locator.value.amount}              jquery=tender-subject-info>div.row:contains("Повний доступний бюджет закупівлі, грн.:")>:eq(1)>
${locator.tenderPeriod.startDate}    jquery=tender-procedure-info>div.row:contains("Початок прийому пропозицій:")>:eq(1)>
${locator.tenderPeriod.endDate}      jquery=tender-procedure-info>div.row:contains("Завершення прийому пропозицій:")>:eq(1)>
${locator.enquiryPeriod.startDate}   jquery=tender-procedure-info>div.row:contains("Початок періоду уточнень:")>:eq(1)>
${locator.enquiryPeriod.endDate}     jquery=tender-procedure-info>div.row:contains("Завершення періоду уточнень:")>:eq(1)>

*** Keywords ***
Підготувати дані для оголошення тендера
  ${INITIAL_TENDER_DATA}=  prepare_test_tender_data
  [return]   ${INITIAL_TENDER_DATA}

Підготувати клієнт для користувача
  [Arguments]  @{ARGUMENTS}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  ...      ${ARGUMENTS[0]} ==  username
  Open Browser   ${USERS.users['${ARGUMENTS[0]}'].homepage}   alias=${ARGUMENTS[0]}
  Set Window Size   @{USERS.users['${ARGUMENTS[0]}'].size}
  Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}

# login
  Wait Until Page Contains Element   id=inputUsername   100
  Input text   id=inputUsername      ${USERS.users['${username}'].login}
  Input text   id=inputPassword      ${USERS.users['${username}'].password}
  Click Button   id=btn_submit

Створити тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_data

  ${items}=         Get From Dictionary   ${ARGUMENTS[1].data}               items
  ${title}=         Get From Dictionary   ${ARGUMENTS[1].data}               title
  ${description}=   Get From Dictionary   ${ARGUMENTS[1].data}               description
  ${budget}=        Get From Dictionary   ${ARGUMENTS[1].data.value}         amount
  ${step_rate}=     Get From Dictionary   ${ARGUMENTS[1].data.minimalStep}   amount
  ${items_description}=   Get From Dictionary   ${ARGUMENTS[1].data}         description
  ${quantity}=      Get From Dictionary   ${items[0]}                        quantity
  ${cpv}=           Get From Dictionary   ${items[0].classification}         id
  ${dkpp_desc}=     Get From Dictionary   ${items[0].additionalClassifications[0]}   description
  ${dkpp_id}=       Get From Dictionary   ${items[0].additionalClassifications[0]}  id
  ${unit}=          Get From Dictionary   ${items[0].unit}                   name
  ${start_date}=    Get From Dictionary   ${ARGUMENTS[1].data.tenderPeriod}   startDate
  ${start_date}=    convert_date_to_etender_format   ${start_date}
  ${start_time}=    Get From Dictionary   ${ARGUMENTS[1].data.tenderPeriod}   startDate
  ${start_time}=    convert_time_to_etender_format   ${start_time}
  ${end_date}=      Get From Dictionary   ${ARGUMENTS[1].data.tenderPeriod}   endDate
  ${end_date}=      convert_date_to_etender_format   ${end_date}
  ${end_time}=      Get From Dictionary   ${ARGUMENTS[1].data.tenderPeriod}   endDate
  ${end_time}=   convert_time_to_etender_format      ${end_time}
  ${enquiry_end_date}=   Get From Dictionary         ${ARGUMENTS[1].data.enquiryPeriod}   endDate
  ${enquiry_end_date}=   convert_date_to_etender_format   ${enquiry_end_date}
  ${enquiry_end_time}=   Get From Dictionary              ${ARGUMENTS[1].data.enquiryPeriod}   endDate
  ${enquiry_end_time}=   convert_time_to_etender_format   ${enquiry_end_time}

  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Wait Until Page Contains          Мої закупівлі    100
  Click Element                     xpath=//a[contains(@class, 'ng-binding')][./text()='Мої закупівлі']
  Wait Until Page Contains Element  xpath=//a[contains(@class, 'btn btn-info')]
  Click Element                     xpath=//a[contains(@class, 'btn btn-info')]
  Wait Until Page Contains Element  id=title
  Input text    id=title                  ${title}
  Input text    id=description            ${description}
  Input text    id=value                  ${budget}
  Click Element                     xpath=//div[contains(@class, 'form-group col-sm-6')]//input[@type='checkbox']
  Input text    id=minimalStep            ${step_rate}
  Input text    id=itemsDescription       ${items_description}
  Input text    id=itemsQuantity          ${quantity}
  Click Element  xpath=//select[@name="itemsUnit"]/option[@value='kilogram']
  Input text    xpath=//div[contains(@class, 'form-group col-sm-8')]//input[@name='enqPEndDate']   ${enquiry_end_date}
  Input text    xpath=//div[contains(@class, 'form-group col-sm-8')]//div[contains(@class, 'col-sm-2')]//input[@ng-model='data.enquiryPeriod.endDate']   ${enquiry_end_time}

  Input text    xpath=//div[contains(@class, 'form-group col-sm-8')]//input[@name='startDate']   ${start_date}
  Input text    xpath=//div[contains(@class, 'form-group col-sm-8')]//div[contains(@class, 'col-sm-2')]//input[@ng-model='data.tenderPeriod.startDate']   ${start_time}
  Input text    xpath=//div[contains(@class, 'form-group col-sm-8')]//input[@name='endDate']   ${end_date}
  Input text    xpath=//div[contains(@class, 'form-group col-sm-8')]//div[contains(@class, 'col-sm-2')]//input[@ng-model='data.tenderPeriod.endDate']   ${end_time}

  Click Element   xpath=//div[contains(@class, 'col-sm-2')]//input[@data-target='#classification']
  Wait Until Page Contains   Оберіть класифікатор CPV   100
  Input text   xpath=//div[contains(@class, 'modal-content')]//input[@ng-model='searchstring']   ${cpv}
  Wait Until Page Contains    Картонки  100
  Click Element   xpath=//table[contains(@class, 'table table-hover table-striped table-bordered ng-table-rowselected ng-scope ng-table')]//tr[1]//td[1]
  Wait Until Page Contains    44617100-9 Картонки   100
  Click Element   xpath=//div[contains(@class, 'modal-content')]//button[@ng-click='choose()']

  Click Element   xpath=//div[contains(@class, 'col-sm-2')]//input[@data-target='#addClassification']
  Wait Until Page Contains   Класифікатор ДКПП   100
  Input text      xpath=//div[contains(@class, 'modal fade ng-scope in')]//input[@ng-model='searchstring']    ${dkpp_desc}
  Wait Until Page Contains   ${dkpp_id}    100
  Click Element   xpath=//table[contains(@class, 'table table-hover table-striped table-bordered ng-table-rowselected ng-scope ng-table')]//tr[2]//td[1]
  Wait Until Page Contains    17.21.1 "Папір і картон гофровані, паперова й картонна тара"   100
  Click Element   xpath=//div[contains(@class, 'modal fade ng-scope in')]//button[@ng-click='choose()']
  Click Element   xpath=//div[contains(@class, 'form-actions')]//button[@type='submit']
  Wait Until Page Contains    [ТЕСТУВАННЯ]   100
  Click Element   xpath=//table[contains(@class, 'table table-hover table-striped table-bordered ng-scope ng-table')]//tr[1]//a
  ${tender_UAid}=   Wait Until Keyword Succeeds   240sec   2sec   get tender UAid
###  harcode Idis bacause issues on the E-tender side, to remove, 1 line:
  ${tender_UAid}=   Convert To String   UA-2015-06-12-000038
  ${Ids}   Create List    ${tender_UAid}
  [return]  ${Ids}

get tender UAid
  ${tender_UAid}=  Get Text  xpath=//div[contains(@class, "panel-heading")]
  ${tender_UAid}=  Get Substring  ${tender_UAid}  7  27
  [return]  ${tender_UAid}

Oтримати internal id по UAid
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderid
  etender.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  ${current_location}=   Get Location
  ${tender_id}=   Fetch From Right   ${current_location}   /
###  harcode Idis bacause issues on the E-tender side, to remove, 1 line:
  ${tender_id}=     Convert To String   94ffe180019d459787aafe290cd300e2
  log  ${internal_id}
  [return]  ${internal_id}

Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderId

  Switch browser   ${ARGUMENTS[0]}
  Go to   ${BROKERS['${USERS.users['${username}'].broker}'].url}
  Wait Until Page Contains   Список закупівель    10
  sleep  1
  Input Text  jquery=input[ng-change='search()']  ${ARGUMENTS[1]}
  Click Link  jquery=a[ng-click='search()']
  sleep  2
  Click Link    jquery=a[href^="#/tenderDetailes"]
  Wait Until Page Contains    ${ARGUMENTS[1]}   10
  sleep  1
  Capture Page Screenshot

обновити сторінку з тендером
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderId
  ...      ${ARGUMENTS[2]} ==  id
  ${current_location}=   Get Location
  Run keyword if   '${BROKERS['${USERS.users['${username}'].broker}'].url}/#/tenderDetailes/${ARGUMENTS[2]}'=='${current_location}'  Reload Page
  Run keyword unless   '${BROKERS['${USERS.users['${username}'].broker}'].url}/#/tenderDetailes/${ARGUMENTS[2]}'=='${current_location}'  Пошук тендера по ідентифікатору   @{ARGUMENTS}
  Wait Until Page Contains    ${ARGUMENTS[1]}   10
  sleep  1

отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  fieldname
  Switch browser   ${ARGUMENTS[0]}
  ${return_value}=  run keyword  отримати інформацію про ${ARGUMENTS[1]}
  [return]  ${return_value}

Відмітити на сторінці поле з тендера
  [Arguments]   ${fieldname}  ${locator}
  ${last_note_id}=  Add pointy note   ${locator}   Found ${fieldname}   width=200  position=bottom
  Align elements horizontally    ${locator}   ${last_note_id}
  sleep  1
  Remove element   ${last_note_id}

Отримати тест із поля і показати на сторінці
  [Arguments]   ${fieldname}
  sleep  3
#  відмітити на сторінці поле з тендера   ${fieldname}   ${locator.${fieldname}}
  ${return_value}=   Get Text  ${locator.${fieldname}}
  [return]  ${return_value}

отримати інформацію про tenderId
  ${return_value}=   Отримати тест із поля і показати на сторінці   tenderId
  [return]  ${return_value.split(' ')[1]}

отримати інформацію про title
  ${return_value}=   Отримати тест із поля і показати на сторінці   title
  [return]  ${return_value}

отримати інформацію про description
   ${return_value}=   Отримати тест із поля і показати на сторінці   description
  [return]  ${return_value}

отримати інформацію про minimalStep.amount
  ${return_value}=   Отримати тест із поля і показати на сторінці   minimalStep.amount
  ${return_value}=   Convert To Number   ${return_value.split(' ')[0]}
  [return]  ${return_value}

отримати інформацію про procuringEntity.name
  ${return_value}=   Отримати тест із поля і показати на сторінці   procuringEntity.name
  [return]  ${return_value}


отримати інформацію про value.amount
  ${return_value}=   Отримати тест із поля і показати на сторінці  value.amount
  ${return_value}=   Evaluate   "".join("${return_value}".split(' ')[:-3])
  ${return_value}=   Convert To Number   ${return_value}
  [return]  ${return_value}

отримати інформацію про tenderPeriod.startDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  tenderPeriod.startDate
  [return]  ${return_value}

отримати інформацію про tenderPeriod.endDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  tenderPeriod.endDate
  [return]  ${return_value}

отримати інформацію про enquiryPeriod.startDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  enquiryPeriod.startDate
  [return]  ${return_value}

отримати інформацію про enquiryPeriod.endDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  enquiryPeriod.endDate
  [return]  ${return_value}


отримати інформацію про items[${item_id}].description
  відмітити на сторінці поле з тендера   items[${item_id}].description   jquery=tender-subject-info.ng-isolate-scope>div.row:contains("Детальний опис предмету закупівлі:")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-subject-info.ng-isolate-scope>div.row:contains("Детальний опис предмету закупівлі:")>:eq(1)>
  [return]  ${return_value}

отримати інформацію про items[${item_id}].quantity
  відмітити на сторінці поле з тендера   items[${item_id}].quantity   jquery=tender-subject-info.ng-isolate-scope>div.row:contains("Кількість:")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-subject-info.ng-isolate-scope>div.row:contains("Кількість:")>:eq(1)>
  ${return_value}=  Convert To Number   ${return_value}
  [return]  ${return_value}

отримати інформацію про items[${item_id}].classification.id
  відмітити на сторінці поле з тендера   items[0].classification.id   jquery=tender-subject-info>div.row:contains("Класифікатор CPV:")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-subject-info>div.row:contains("Класифікатор CPV:")>:eq(1)>
  [return]  ${return_value.split(' ')[0]}

отримати інформацію про items[${item_id}].classification.scheme
  відмітити на сторінці поле з тендера   items[0].classification.id   jquery=tender-subject-info>div.row:contains("CPV")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-subject-info>div.row:contains("CPV")>:eq(1)>
  [return]  ${return_value.split(' ')[0]}

отримати інформацію про items[${item_id}].classification.description
  відмітити на сторінці поле з тендера   classification.description   jquery=tender-subject-info>div.row:contains("Класифікатор CPV:")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-subject-info>div.row:contains("Класифікатор CPV:")>:eq(1)>
  ${return_value}=   catenate  @{return_value.split(' ')[1:]}
  [return]  ${return_value}

отримати інформацію про items[${item_id}].deliveryAddress
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[${item_id}].deliveryAddress
  [return]  ${return_value}

отримати інформацію про items[${item_id}].deliveryDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[${item_id}].deliveryDate
  [return]  ${return_value}

отримати інформацію про questions[${question_id}].title
  відмітити на сторінці поле з тендера   questions title   jquery=tender-questions>div:eq(1)>div.row:contains("Тема:")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-questions>div:eq(1)>div.row:contains("Тема:")>:eq(1)>
  [return]  ${return_value}

отримати інформацію про questions[${question_id}].description
  відмітити на сторінці поле з тендера   questions description   jquery=tender-questions>div:eq(1)>div.row:contains("Питання:")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-questions>div:eq(1)>div.row:contains("Питання:")>:eq(1)>
  [return]  ${return_value}

отримати інформацію про questions[${question_id}].date
  відмітити на сторінці поле з тендера   question date   jquery=tender-questions>div:eq(1)>div.row:contains("Дата:")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-questions>div:eq(1)>div.row:contains("Дата:")>:eq(1)>
  [return]  ${return_value}

отримати інформацію про questions[${question_id}].answer
  відмітити на сторінці поле з тендера   question answer   jquery=tender-questions>div:eq(1)>div:last>
  ${return_value}=   Get Text  jquery=tender-questions>div:eq(1)>div:last>
  [return]  ${return_value}

Подати цінову пропозицію
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${INTERNAL_TENDER_ID}
  ...      ${ARGUMENTS[2]} ==  test_bid_data

  ${bid}=        Get From Dictionary   ${ARGUMENTS[2].data.value}         amount
  etender.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Wait Until Page Contains          Інформація про процедуру закупівлі    100
  Wait Until Page Contains Element          id=amount   10
  Input text    id=amount                  ${bid}
  Click Element                     xpath=//button[contains(@class, 'btn btn-success')][./text()='Реєстрація пропозиції']
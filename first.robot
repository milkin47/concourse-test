*** Settings ***
Library     Collections
Library     RequestsLibrary

*** Variables ***
${base_url}      http://216.10.245.166
${book_id}

*** Test Cases ***
Dictionary
    [Tags]      SMOKE
    &{data}=    create dictionary    a=1     b=2     c=3     d=4
    log     ${data}
    Dictionary Should Contain Key     ${data}       a
    ${dict}=    get from dictionary     ${data}     d
    log    ${dict}


API Post call
    [TAGS]      API
    &{payload}=     create dictionary    name=API_Robot     isbn=3412634      aisle=419   author=chetan
    ${response_post}=    POST    ${base_url}/Library/Addbook.php     json=${payload}      expected_status=200
    log    ${response_post.json()}
    Dictionary Should Contain Key       ${response_post.json()}     ID
    status should be    200     ${response_post}
    ${book_id}=     get from dictionary     ${response_post.json()}     ID
    log     ${book_id}
    set global variable  ${book_id}
    should be equal as strings      successfully added      ${response_post.json()}[Msg]

API Get call
    [TAGS]      API
    ${response_get}=    GET    ${base_url}//Library/GetBook.php     params=ID=${book_id}    expected_status=200
    log     ${response_get.json()}
    should be equal as strings   API_Robot      ${response_get.json()}[0][book_name]

API Delete call
    [TAGS]      API
    &{del_dict}     create dictionary       ID=${book_id}
    ${response_delete}=     POST        ${base_url}/Library/DeleteBook.php      json=${del_dict}    expected_status=200
    log     ${response_delete.json()}
    should be equal as strings  ${response_delete.json()}[msg]      book is successfully deleted

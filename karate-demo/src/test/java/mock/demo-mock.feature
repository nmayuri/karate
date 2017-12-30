Feature:

Background:
* def nextId = call read('increment.js')
* def cats = {}

Scenario: pathMatches('/greeting') && paramValue('name') != null
    * def content = 'Hello ' + paramValue('name') + '!'
    * def response = { id: '#(nextId())', content: '#(content)' }

Scenario: pathMatches('/greeting')
    * def response = { id: '#(nextId())', content: 'Hello World!' }

Scenario: pathMatches('/cats') && methodIs('post') && typeContains('xml')
    * def cat = request    
    * def id = nextId()
    * set cat /cat/id = id    
    * set catJson
        | path | value        |
        | id   | id           |
        | name | cat.cat.name |
    * eval cats[id + ''] = catJson
    * def response = cat

Scenario: pathMatches('/cats') && methodIs('post')
    * def cat = request
    * def id = nextId()
    * set cat.id = id
    * eval cats[id + ''] = cat
    * def response = cat

Scenario: pathMatches('/cats/{id}') && acceptContains('xml')
    * def cat = cats[pathParams.id]
    * def response = <cat><id>#(cat.id)</id><name>#(cat.name)</name></cat>

Scenario: pathMatches('/cats/{id}')
    * def response = cats[pathParams.id]

Scenario: pathMatches('/cats/{id}/kittens')
    * def response = cats[pathParams.id].kittens
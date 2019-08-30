# Freefrom Compensation Backend

## Overview
FreeFrom is a nonprofit dedicated to helping survivors of domestic violence achieve financial stability. On their website they have a [compensation tool](https://compensation-quiz.freefrom.org/) where users can answer a series of questions in order to get information about financial resources that are available to them depending on their state.

This repository contains the new Rails backend for the compensation tool and the CMS that allows FreeFrom administrators to change the content in the tool.

## Local Development Setup
### Install Ruby
Make sure you have ruby version 2.6.3 installed on your local machine, or install it using this guide: https://www.ruby-lang.org/en/documentation/installation/

### Install PostgreSQL
Install and run a PostgreSQL version 11.4.

### Set up database roles
1. Start a Postgres client session: `psql`
2. Create a new user: `create user "freefrom-compensation-api-user";`
3. Give that user special permissions: `alter user "freefrom-compensation-api-user" with superuser;`
4. Exit out of the client session: `exit`

### Install Rails
Run the command `gem install rails` (make sure `rails --version` returns 5.2.3)

### Set up app
1. Clone this repository onto your local machine
2. `cd` into the `freefrom-compensation-api` folder
3. Run `bundle install` to install the app's dependencies (run `gem install bundler` if that doesn't work)
4. Run `rake db:setup` to create the test and development databases
5. Run `rake db:migrate` to set up the necessary database tables
6. Run `bundle exec rails s` to start the server

## API Documentation
### Users and Authentication
#### POST /user_tokens
Generates a new [JWT](https://jwt.io/introduction/) for the user whose authentication information is specified in the request payload.

_Request Payload:_
```
{
 "auth": {
   "email": "foo@bar.com",
   "password": "secret"
 }
}
```

_Response Payload:_
On success, this endpoint will return a `201 Created` response status as well as a body with a new JWT in the shape:
```
{"jwt": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9"}
```
On failure, this endpoint will return `401 Unauthorized`.

#### GET /users/current
Returns a serialized representation of the user as long as a valid JWT is passed as a header.

_Request Headers:_
```
{
  Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9
}
```

_Response Payload:_
On success, this endpoint will return a `200 Success` status and a JSON representation of the user corresponding to the JWT:
```
{
  "id": 3,
  "username": "foo",
  "email": "foo@bar.com",
  "role": "admin"
}
```
On failure, this endpoint will return `401 Unauthorized`.

### Resource Categories
#### POST /resource_categories**
Creates a new Resource Category.

_Request Payload_: This endpoint does not require any request payload.

_Response Payload_: On success, this endpoint will return a `201 Created` status and a new resource category object in the response body.
```
{
  "id": 1,
  "name": null,
  "short_description": null,
  "description": null,
  "icon": null,
  "seo_title": null,
  "seo_description": null,
  "seo_keywords": [],
  "share_image": null,
  "created_at": "2019-08-02T16:16:36.282Z",
  "updated_at": "2019-08-02T16:16:36.282Z"
}
```

#### PUT /resource_categories/:id**
Updates an existing Resource Category.

_Request Payload_: The request payload may include any of the following fields. To leave a field unchanged, just do not include it in the request payload. (Including a field and setting it's value to `null` in the request payload will erase that field value from the Resource Category.)

|Field name|Type|
|---|---|
|`short_description`|string| 
|`name`|string|
|`description`|string|
|`icon`|binary|
|`seo_title`|string|
|`seo_description`|string|
|`seo_keywords`|array[string]|
|`share_image`|binary|

_Response Payload_: On success, this endpoint will return a `200 Success` response and the updated Resource Category in the response body. If the request was unauthorized, it will return a `401 Unauthorized` status. If the Resource Category doesn't exist, it will return a `404 Not Found` response.

#### DELETE /resource_categories/:id**
Deletes an existing Resource Category.

_Request Payload_: This endpoint requires no request payload.

_Response Payload_: On success, this endpoint will return a `204 No Content` response and an empty response body. If the request was unauthorized, it will return a `401 Unauthorized` status. If the Resource Category doesn't exist, it will return a `404 Not Found` response.

#### GET /resource_categories/:id
Fetches an existing Resource Category.

_Request Payload_: This endpoint requires no request payload.

_Response Payload_: On success, this endpoint will return a `200 Success` status and a Resource Category in the response body. If the Resource Category doesn't exist, it will return a `404 Not Found` response.

### Resources
#### POST /resource_categories/:id/resources?state=:state**
Creates a new Resource.

_Request Params_: This endpoint requires that a valid US state code (e.g. "NY" or "ME") be passed in with the `state` param.

_Response Payload_: On success, this endpoint will return a `201 Created` status and a new resource object in the response body.
```
{
  "id": 1,
  "state": "NY",
  "time": null,
  "cost": null,
  "award": null,
  "likelihood": null,
  "safety": null,
  "story": null,
  "challenges": null,
  "resource_category_id": 2,
  "created_at": "2019-08-02T16:36:09.933Z",
  "updated_at": "2019-08-02T16:36:09.933Z"
}
```
If the request was unauthorized, it will return a `401 Unauthorized` status. If the Resource Category ID or state parameter are invalid, this endpoint will return a `400 Bad Request` response, along with an error message explaining what went wrong.


#### PUT /resources/:id**
Updates an existing Resource.

_Request Payload_: The request payload may include any of the following fields. To leave a field unchanged, just do not include it in the request payload. (Including a field and setting it's value to `null` in the request payload will erase that field value from the Resource.)

|Field name|Type|
|---|---|
|`state`|string| 
|`time`|string|
|`cost`|string|
|`award`|string|
|`likelihood`|string|
|`safety`|string|
|`story`|string|
|`challenges`|string|
|`resource_category_id`|int|

_Response Payload_: On success, this endpoint will return a `200 Success` response and the updated Resource in the response body. If the request was unauthorized, it will return a `401 Unauthorized` status. If the Resource doesn't exist, it will return a `404 Not Found` response.

#### DELETE /resources/:id**
Deletes an existing Resource.

_Request Payload_: This endpoint requires no request payload.

_Response Payload_: On success, this endpoint will return a `204 No Content` response and an empty response body. If the request was unauthorized, it will return a `401 Unauthorized` status. If the Resource doesn't exist, it will return a `404 Not Found` response.

#### GET /resources/:id
Fetches an existing Resource.

_Request Payload_: This endpoint requires no request payload.

_Response Payload_: On success, this endpoint will return a `200 Success` status and a Resource in the response body. If the Resource doesn't exist, it will return a `404 Not Found` response.

### Resource Steps
##### POST /resource/:id/resource_steps?number=:number**
Creates a new Resource Step.

_Request Params_: This endpoint requires that an integer be passed in the `number` parameter. (The number must be unique for the given resource.)

_Response Payload_: On success, this endpoint will return a `201 Created` status and a new Resource Step in the response body.
```
{
  "id": 1,
  "number": 1,
  "description": null,
  "resource_id": 1,
  "created_at": "2019-08-02T16:55:56.098Z",
  "updated_at": "2019-08-02T16:55:56.098Z"
}
```
If the request was unauthorized, it will return a `401 Unauthorized` status. If the Resource ID or number parameter are invalid, this endpoint will return a `400 Bad Request` response, along with an error message explaining what went wrong.

#### PUT /resource_steps/:id**
Updates an existing Resource Step.

_Request Payload_: The request payload may include any of the following fields. To leave a field unchanged, just do not include it in the request payload. (Including a field and setting it's value to `null` in the request payload will erase that field value from the Resource Step.)

|Field name|Type|
|---|---|
|`number`|int| 
|`description`|string|
|`resource_id`|int|

_Response Payload_: On success, this endpoint will return a `200 Success` response and the updated Resource Step in the response body. If the request was unauthorized, it will return a `401 Unauthorized` status. If the Resource Step doesn't exist, it will return a `404 Not Found` response.

#### DELETE /resources_steps/:id**
Deletes an existing Resource Step.

_Request Payload_: This endpoint requires no request payload.

_Response Payload_: On success, this endpoint will return a `204 No Content` response and an empty response body. If the request was unauthorized, it will return a `401 Unauthorized` status. If the Resource Step doesn't exist, it will return a `404 Not Found` response.

#### GET /resources/:id
Fetches an existing Resource Step.

_Request Payload_: This endpoint requires no request payload.

_Response Payload_: On success, this endpoint will return a `200 Success` status and a Resource Step in the response body. If the Resource  Step doesn't exist, it will return a `404 Not Found` response.

** Requires a JWT to be passed in as a header:
```
{
  Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9
}
```

## Contributing
To contribute, see [CONTRIBUTING.md](./contributing.md)

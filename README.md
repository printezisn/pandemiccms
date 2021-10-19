<h1>
  <img src="public/logo.png" alt="logo" />
  &nbsp;
  Pandemic CMS
</h1>

A CMS with all the necessary components to help you create fast and amazing websites. Why Pandemic CMS ? Because it was created during the pandemic. Here is the core philosophy of it:
- It provides core entities to help you get started fast, but it's designed to be easily extended with new entities. The core entities are the following:
  - Posts
  - Categories
  - Tags
  - Pages
  - Menus
  - Media
  - Settings
  - Email Templates
  - Users
  - Redirects
- The majority of web applications need a dashboard to keep track of users, edit settings and handle content. Pandemic CMS is designed to be easily extended and become that dashboard for your web applications, from simple blogs to big SaaS.
- Many applications need to support multiple languages. This is easy for static content, but what about dynamic content ? Pandemic CMS is designed to support multilingual content.
- Pandemic CMS is designed to be multi-tenant, meaning that it is possible to support multiple applications/clients on the same instance.

## Stack

**Programming languages**:

- Ruby
- JavaScript

**Web**:

- Ruby on Rails
- NodeJS

**Testing**:

- RSpec
- Factory Bot

**Linting**:

- Rubocop
- ESLint

**Requirements**

You need to have the following installed to run the project:

- Ruby
- NodeJS
- MySQL (or MariaDB)
- Redis
- Elasticsearch
- ImageMagick
- Sidekiq

## How to prepare

**1. Install dependencies**:

- `bundle install`
- `yarn`

**2. Add configuration**:

Add configuration by running `EDITOR=<editor> rails credentials:edit`. The credentials file contains configuration for the following services:
- MySQL/MariaDB
- Redis
- Elasticsearch
- SMTP mail server
- Sidekiq Web UI

and it has the following structure:

```
secret_key_base: <secret_key_base>
mysql:
  host: <host>
  username: <username>
  password: <password>
redis:
  host: <host>
  port: <port>
  password: <password>
elasticsearch:
  url: <url>
  username: <username>
  password: <password>
smtp:
  host: <host>
  port: <port>
sidekiq_ui:
  username: <username>
  password: <password>
```

If you need to generate a new value for `secret_key_base`, you can do it by running `rails secret`.

Also, you can generate different configuration for production by running `EDITOR=<editor> rails credentials:edit --environment production`. This will generate a new `production.key` file whose value needs to be stored on the server in a secure way.

**3. Create the database**:

Log in the database system and perform the following actions:

1. Create the development database with `CREATE DATABASE pandemiccms;`.
1. Create the test database with `CREATE DATABASE pandemiccms_test`.

**4. Run the database migrations**:

Run the migrations with `bundle exec rails db:migrate`.

**5. Add initial database data**:

Run `bundle exec rake pandemiccms:init`. This will add the initial data to the database.

**6. Create a client**:

Run `bundle exec rake pandemiccms:create_client -- -n CLIENT_NAME -t TEMPLATE -d DOMAIN:PORT` to create a client.

For example: `bundle exec rake pandemiccms:create_client -- -n "Pandemic CMS" -t sample -d mysite:80 -d localhost:3000`.

For more information, you can run `bundle exec rake pandemiccms:create_client -- -h` for help.

**7. Create a supervisor user**:

Run `bundle exec rake pandemiccms:create_supervisor -- -u USERNAME -e EMAIL -p PASSWORD -c CLIENT_NAME` to create a supervisor user.

For example: `bundle exec rake pandemiccms:create_supervisor -- -u username -e me@email.com -p mypass -c "Pandemic CMS"`.

For more information, you can run `bundle exec rake pandemiccms:create_supervisor -- -h` for help.

## How to run

**Run the linters**:

- `bundle exec rubocop`
- `yarn lint`

**Run the tests**:

`bundle exec rspec`

**Run sidekiq**:

`bundle exec sidekiq`

Sidekiq is responsible for running background jobs.

**Run the application**:

`bundle exec rails s`

## Rake tasks

1. `bundle exec rake pandemiccms:init`: Initializes the necessary data for the application.
1. `bundle exec rake pandemiccms:create_client -- [OPTIONS]`: Creates a new client.
1. `bundle exec rake pandemiccms:create_supervisor -- [OPTIONS]`: Creates a new supervisor user.

## Docker compose

- `docker-compose.infrastructure.yml`: Spins up all infrastructure services (MariaDB, etc.).
- `docker-compose.yml`: Spins up all infrastructure services and the application.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

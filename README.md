<h1>
  <img src="public/logo.png" alt="logo" />
  &nbsp;
  Pandemic CMS
</h1>

A CMS, created in the pandemic, which can do the following for you:

- Handle common CMS entities:

  - Posts
  - Categories
  - Tags
  - Pages
  - Menus
  - Media
  - Settings
  - Users

- Support multiple tenants/sites in the same instance.
- Support multiple languages.

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

## How to prepare

**1. Install dependencies**:

- `bundle install`
- `yarn`

**2. Add configuration**:

Add configuration by running `EDITOR=<editor> rails credentials:edit`. The credentials file contains configuration for MySQL/MariaDB and must have the following structure:

```
secret_key_base: <secret_key_base>
mysql:
  host: <host>
  username: <username>
  password: <password>
```

If you need to generate a new value for `secret_key_base`, you can do it by running `rails secret`.

Also, you can generate different configuration for production by running `EDITOR=<editor> rails credentials:edit --environment production`. This will generate a new `production.key` file whose value needs to be stored on the server in a secure way (e.g. environment variable).

**3. Create the database**:

Log in the database system and perform the following actions:

1. Create the development database with `CREATE DATABASE pandemiccms;`.
1. Create the test database with `CREATE DATABASE pandemiccms_test`.

**4. Run the database migrations**:

Run the migrations with `bundle exec rails db:migrate`.

**5. Add SMTP settings**:

Open the `config/environments/development.rb` file and configure the `config.action_mailer.smtp_settings` setting to point to your mail server.
Please note that you need to do the same for the other environments too.

**6. Run the setup script**:

Run the setup script with `bundle exec rails r ./setup.rb` and follow the instructions to set up the appropriate data.
Afterwards, you'll be able to sign in with the supervisor user which you created.

## How to run

**Run the linters**:

- `bundle exec rubocop`
- `yarn lint`

**Run the tests**:

`bundle exec rspec`

**Run the application**:

`bundle exec rails s`

## How to deploy

You must first tweak the capistrano-related files to work for your infrastructure. Then, you can deploy with `bundle exec cap production deploy`.

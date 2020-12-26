# Pandemic CMS

A CMS, created in the pandemic, which can do the following for you:

- Handle common CMS entities:

  - Posts
  - Pages
  - Menus
  - Media
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

Copy the `.env.sample` file to `.env`, open it and fill the environment variables with the desired configuration:

- `MYSQL_HOST`: The database host address.
- `MYSQL_USER`: The user to log in the database.
- `MYSQL_PASSWORD`: The password to log in the database.

**3. Create the database**:

Log in the database system and perform the following actions:

1. Create the development database with `CREATE DATABASE pandemiccms;`.
1. Create the test database with `CREATE DATABASE pandemiccms_test`.

**4. Run the database migrations**:

Run the migrations with `bundle exec rails db:migrate`.

**5. Add SMTP settings**:

Open the `config/environments/development.rb` file and configure the `config.action_mailer.smtp_settings` setting to point to your mail server.
Please note that you need to do the same for the other environments too.

**5. Create the first admin user**:

Open the rails console with `bundle exec rails c` and create the first local admin user with the following statements:

```
user = AdminUser.new(
  email: '<email>',
  username: '<username>',
  password: '<password>',
  client_id: 'local',
  roles: [AdminUser::SUPERVISOR_ROLE])
user.save!
user.confirm
```

This user is a supervisor and can manage other users too.

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

## Configuration

### Add a new tenant

1. Add a new entry in the `config/tenants.yml` file. Configuration for a tenant includes the following information:
   - `id`: The unique identifier of the tenant.
   - `name`: The name of the tenant.
   - `default_url_options`: The default url options used in email templates for the tenant.
   - `locales`: The available languages for the tenant. Each locale entry contains the language name and flag.
1. Create a logo and favicon for the tenant and place them under the `public/tenants/<tenant_id>` directory.
1. Create an `_admin_logo.html.erb` file under the `app/views/shared/<tenant_id>/` directory. It contains the admin banner for the tenant.
1. Create an `_admin_footer.html.erb` file under the `app/views/shared/<tenant_id>/` directory. It contains the admin footer for the tenant.

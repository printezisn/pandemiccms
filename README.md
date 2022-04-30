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

![https://pandemiccms.com](README/admin_dashboard.jpeg)

Website: https://pandemiccms.com

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
- libvips
- Sidekiq

## How to prepare

**1. Set up required components**:

In order to run the project, you have to install the following components:

1. Ruby (3.1.0)
1. NodeJS
1. MariaDB (or MySQL) *
1. Redis *
1. Elasticsearch *
1. libvips

\* You may skip the installation of these components if you want and use the `docker-compose.infrastructure.yml` instead.

You may actually skip the whole step if you use [remote containers](https://code.visualstudio.com/docs/remote/containers) with Visual Studio Code. It also spins up `docker-compose.infrastructure.yml` for you.

**2. Install dependencies**:

- `bundle install`
- `yarn`

**3. Add configuration**:

Add configuration by running `EDITOR=<editor> rails credentials:edit` (e.g. `EDITOR="code --wait" rails credentials:edit`). The credentials file contains configuration for the following services:
- MySQL/MariaDB
- Redis
- Elasticsearch
- Super admin areas (e.g. Sidekiq Web UI)

and it has the following structure:

```
secret_key_base: <secret_key_base>
mariadb:
  username: <username>
  password: <password>
redis:
  password: <password>
elasticsearch:
  username: <username>
  password: <password>
super_admin:
  username: <username>
  password: <password>
```

If you need to generate a new value for `secret_key_base`, you can do it by running `rails secret`.

Also, you can generate different configuration for production by running `EDITOR=<editor> rails credentials:edit --environment production`. This will generate a new `production.key` file whose value needs to be stored on the server in a secure way.

For the development environment, the project contains a default credentials file with a `master.key` file to open it.

**4. Create the database**:

You have to follow these instructions only if you don't use the default services from `docker-compose.infrastructure.yml`.

Log in the database system and perform the following actions:

1. Create the development database with `CREATE DATABASE pandemiccms;`.
1. Create the test database with `CREATE DATABASE pandemiccms_test;`.
1. Create the production database with `CREATE DATABASE pandemiccms_production;`.

**5. Run the database migrations**:

Run the migrations with `bundle exec rails db:migrate`.

**6. Create your first client**:

Run `./bin/dev` to start the application and visit [http://localhost:3000](http://localhost:3000). It will redirect you to a page to create your first client (you'll need the super admin credentials you added in the configuration in step 3).

After this step is complete, an email will be sent to the supervisor with instructions on how to activate the account. If you're using the default services from `docker-compose.infrastructure.yml`, then you can view all the emails in mailcatcher which is in [http://localhost:1080](http://localhost:1080).

**7. You're done!**

Visit [http://localhost:3000](http://localhost:3000) and enjoy your new client :)

You can sign in to the admin panel by visiting [http://localhost:3000/admin](http://localhost:3000/admin).

**Run the linters**:

- `bundle exec rubocop`
- `yarn lint`

**Run the tests**:

`bundle exec rspec`

**Run the application**:

`./bin/dev`

## Docker compose

- `docker-compose.infrastructure.yml`: Spins up all infrastructure services (MariaDB, etc.).
- `docker-compose.yml`: Spins up all infrastructure services and the application.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributors

<a href="https://github.com/printezisn">
  <img src="https://avatars.githubusercontent.com/u/28266572?v=4" width="80" height="80" title="printezisn" alt="printezisn" />
</a>
&nbsp;
<a href="https://github.com/cvrac">
  <img src="https://avatars.githubusercontent.com/u/10595219?v=4" width="80" height="80" title="cvrac" alt="cvrac" />
</a>

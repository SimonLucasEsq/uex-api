# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Instala las siguientes herramientas previas a la instalación:
  * Ruby: 3.1.2
  * PostgreSQL: 9.3
* Crea un usuario con contraseña para PostgreSQL
* Corre el comando de abajo, esto nos creará un archivo para las credenciales si ya tenemos creado nos creará uno nuevo:
```
EDITOR="code --wait" rails credentials:edit --environment=development
```
* Modifica el archivo y agrega las credenciales. Ver el ejemplo:
```
jwt_signing_key: "UEX development"
database:
  database: "uex_development"
  username: "uex_db_user"
  password: "kWIblYWsgE5PHvSPxjW0aapg8zDiExma"
  host: "postgres://uex_db_user:kWIblYWsgE5PHvSPxjW0aapg8zDiExma@dpg-cl2qt29novjs73b6a030-a.oregon-postgres.render.com/uex_db"
client_host: "localhost:5173"
```
* Abre la terminal e dirígete hasta raíz del código fuente y ejecuta:
```
bundle install
```
* Ejecuta los siguientes comandos para crear la base de datos, correr las migraciones y
rellenarla con datos generales especificados en el archivo seeds.rb:
```
rake db:create
rake db:migrate
rake db:seed 
```
* Para correr la aplicación en los diferentes entornos de desarrollo es necesario ejecutar
los siguientes comandos:
  * Desarrollo: `rails s`
  * Producción:
```
rails assets:precompile RAILS_ENV=production
rails server -e production
```
* Para correr los tests ejecuta los siguientes comandos:
```
rake db:test:prepare
rspec spec/
```

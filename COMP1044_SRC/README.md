# COMP1044 Databases and Interfaces CRM
The following project is built for module COMP1044 Databases and Interfaces 24/25 assignment.
The project is built with Vue.js and Tailwind CSS for frontend, and PHP for backend.

## Getting started
Run the following npm command in command prompt to install all the required dependencies to get started:
```bash
npm install
```

## Building the project
Run the following npm command to build the project:
```bash
npm run build
```
The npm shall output a `dist` folder, in which it will contain the main page `index.html` and all the required JS and CSS files.

## Running the project in server
Copy the `backend` and `dist` folder into your server folder location, and you shall be able to run the website.

E.g. copy `backend` and `dist` into `htdocs` of `XAMPP` or `MAMP`, you should be able to run the website by `http://localhost/#/`.

### Note
Pwease note that the website's path is built upon relative path. That is, the folder `backend` and `dist` shall be in the same layer of directory.

Valid directory:
htdocs
  |__ backend
  |__ dist

Invalid directory:
htdocs
  |__ backend
  |__ myWebsite
        |__ dist

The backend setting is as follows:
```php
$dsn = "mysql";
$host = "localhost";
$user = "root";
$password = "root";
$dbname = "uwucrm_abb_db";
```

## User ID and password for login to the website:
1: Aqua@123 (Super Admin)
2: Rinne!372 (Admin)
3: tsUki*7127 (Admin)
4: HACHI_honey13 (Sales Representative)
5: KNHare@17 (Sales Representative)
6: Rizu#1405 (Sales Representative)
7: MIYAkochi@446 (Sales Representative)
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
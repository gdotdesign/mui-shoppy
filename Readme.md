<img src="http://gdotdesign.github.io/mui-shoppy/icon.png" width="26px" /> Shoppy
=================================================================================

Shoppy is an example application of [MUI](http://m-ui.org).            
You can see the application live at http://gdotdesign.github.io/mui-shoppy/

## About
### What?
With Shoppy you can:
 
 * Login / Register
 * Create / Delete / Toggle list items
 * There are 7 categories and a quantity field for items
 * Updates realtime thanks to [Firebase](https://www.firebase.com)

### Why?
This example is created to show you how [MUI](http://m-ui.org) can be used for creating an application, that:
 
 * Small relative to other applications this complex
 * Runs on multiple browsers and platforms the same
 * Loads insanely fast (no templates, no boilerplate)
 * Completly decoupled from the backend
 * Can be served with a simple static server

### How?
This application at runtime only uses [MUI](http://m-ui.org) for frontend, and [Firebase](https://www.firebase.com) for backend.         
For development dependencies see package.json.

### Stats

 * The compiled and minified build is **~100kb**
 * Average load time should be under **300ms**
 * Network load should be under **150kb (Not Cached)** / **5kb (Cached)**

## Hacking

You will need NodeJS for development, PhantomJS / CasperJS for testing.
 
 * Clone the repository: `git clone https://github.com/gdotdesign/mui-shoppy.git`
 * Initialize submodules: `git submodule init && git submodule update`
 * Install dependecies: `cd mui-shoppy && npm install`
 * Run the development server: `npm start`
 * Run tests (the server must be running): `npm test`
 * Build the release: `coffee build.coffe`


------------------------------------------------------------------------------------
Icon / colors from [Flat-UI](http://designmodo.github.io/Flat-UI/)

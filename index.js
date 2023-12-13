const express = require('express');
const path = require('path');
const fs = require('fs');
const bodyParser = require('body-parser');
// const { render } = require('ejs');
const multer = require('multer');
const decompress = require('decompress');
const cp = require('child_process');
const {XMLParser, XMLBuilder} = require('fast-xml-parser');

const app = express();

// Middleware setup
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// Set up static file serving for 'upload' folder
const uploadsPath = path.join(__dirname, 'upload');
app.use('/upload', express.static(uploadsPath));

// Route to render the 'first' view
/**
 * @route GET /
 * @description Render the 'first' view.
 */
app.get("/", function (req, res) {
    res.render('first');
});

// Set up multer storage and upload configuration
const storage1 = multer.diskStorage({
    destination: function (req, file, cb) {
        // Check the fieldname and store files accordingly
        if (file.fieldname === 'appicon' || file.fieldname === 'applogo') {
            cb(null, path.join(__dirname, '/upload'));
        } else {
            cb(new Error('Invalid field name'));
        }
    },
    filename: (req, file, cb) => {
        if (file.fieldname === 'appicon'){
            cb(null, 'appicon.zip');
        }else if (file.fieldname === 'applogo'){
            cb(null, 'applogo.png');
        }else{
            cb(null, file.originalname); // Use the original file name
        }
    }
});
const uploadd = multer({ storage: storage1 });

// Configure multer fields for file uploads
/**
 * @typedef {Object} MulterField
 * @property {string} name - The name of the field for file upload.
 * @property {number} maxCount - The maximum number of files allowed to be uploaded for this field.
 */

/**
 * @type {MulterField[]} fields - Multer fields configuration for file uploads.
 */
const cpUpload = uploadd.fields([
    { name: 'appicon', maxCount: 1 },
    { name: 'applogo', maxCount: 8 },
]);

// Route to handle file upload
/**
 * @route POST /fileupload
 * @description Handle file upload.
 * @returns {void}
 * @throws {Error} If an invalid field name is provided.
 */
app.post('/fileupload', cpUpload, async (req, res) => {
    // console.log(req);
    
    
    //Generate New project
    fs.cpSync('./FleetStack', './projects/temp', {recursive: true});
    console.log('copy new project');
    process.chdir('./projects/temp');
    console.log('change current directory');
    //Launcher Icon
    await decompress('../../upload/appicon.zip', "icons");
    console.log('App Icon extracted');
    fs.cpSync('./icons/android', './android/app/src/main', {recursive: true});
    console.log('App Icon Copy');
    //App Logo
    fs.cpSync('../../upload/applogo.png', './assets/images/logo.png');
    fs.cpSync('../../upload/applogo.png', './assets/images/splash_logo.png');
    console.log('App Logo Copy');

    //AndroidManifest change
    const xmlData= fs.readFileSync('./android/app/src/main/AndroidManifest.xml');
    const xmloptions = { ignoreAttributes: false, attributeNamePrefix: "@_"};
    const parser = new XMLParser(xmloptions);
    let jObj = parser.parse(xmlData);
    console.log(jObj['manifest']['application']);
    jObj['manifest']['application']['@_android:label'] = req.body['appname'];
    const builder = new XMLBuilder(xmloptions);
    fs.writeFileSync('./android/app/src/main/AndroidManifest.xml', builder.build(jObj));
    console.log('AndroidManifest.xml changed');
    //googleservice.json change

    const jsonData = fs.readFileSync('./android/app/google-services.json');
    jObj = JSON.parse(jsonData);
    jObj['client'][0]['client_info']['android_client_info']['package_name'] = req.body['packagename']
    fs.writeFileSync('./android/app/google-services.json', JSON.stringify(jObj));
    console.log('google-services.json file changed');
    //flutter build 
    cp.exec('flutter build appbundle');
    res.redirect('/');
});

// Start the server
/**
 * @description Start the server and listen on port 3001.
 * @event
 */
app.listen(3000, () => {
    console.log('server is running on port http://localhost:3001');
});
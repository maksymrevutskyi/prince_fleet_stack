//Server IP: 34.231.87.205
const express = require('express');
const path = require('path');
const fs = require('fs');
const bodyParser = require('body-parser');
// const { render } = require('ejs');
const multer = require('multer');
const decompress = require('decompress');
const cp = require('child_process');
const {XMLParser, XMLBuilder} = require('fast-xml-parser');
const sql = require('mssql');
const session = require('express-session');
const passport = require('passport');
const app = express();
let pool, user;
// Middleware setup
app.set('view engine', 'ejs');
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'views')));
app.use(express.static(path.join(__dirname, 'projects')));
app.use(session({
    resave: false,
    saveUninitialized: true,
    secret: 'ajskdfjjsdkfj'
}));
app.use(passport.initialize());
app.use(passport.session());

passport.serializeUser((user, cb) => {
    cb(null, user);
});
passport.deserializeUser((obj, cb) => {
    cb(null, obj);
});
const GoogleStrategy = require('passport-google-oauth').OAuth2Strategy;
passport.use(new GoogleStrategy({
    clientID: '72208994701-idvp0cl0oio8u8klo04lh4hvmij3qdc0.apps.googleusercontent.com',
    clientSecret: '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',
    callbackURL: "http://localhost:3000/auth/google/callback"
}, async (accessToken, refreshToken, profile, done) => {
    let users = await pool.request()
    .input('Email', profile.emails[0].value)
    .query('SELECT * FROM dw_ForumUsers WHERE Email=@Email');
    
    if (users.rowsAffected[0] === 0){
        let result = await pool.request()
        .input('Email', profile.emails[0].value)
        .input('Username', profile.displayName)
        .input('Image', profile.photos[0].value)
        .input('Subscription', false)
        .input('PurchaseDone', null)
        .input('OrderPlaced', null)
        .input('IsActive', true)
        .output('UserId', sql.Int)
        .input('RegiteredDate', new Date().toISOString())
        .query('INSERT INTO dw_ForumUsers(Email, Username, Image, Subscription, PurchaseDone, OrderPlaced, IsActive, RegiteredDate, APIKey) VALUES(@Email, @Username, @Image, @Subscription, @PurchaseDone, @OrderPlaced, @IsActive, @RegiteredDate, NEWID());SELECT @ProjectId=SCOPE_IDENTITY()');
        
        
    
        fs.cpSync('./FleetStack', './projects/' + results.output.ProjectId, {recursive: true});
        user = {
            Username: profile.displayName,
            Email: profile.emails[0].value,
            UserId: result.output.UserId
        };
    }else {
        user = users.recordset[0];
    }
    return done(null, profile);
}));

app.get('/buildaab/:id', async(req, res) => {
    process.chdir('./projects/'+req.params.id);
    await cp.exec('flutter build appbundle');
    if (fs.existsSync('./build/app/outputs/bundle/release/app-release.aab')){
        res.sendFile('./build/app/outputs/bundle/release/app-release.aab');
    }else {
        res.send('Error');
    }
});

app.get('/buildapk/:id', async(req, res) => {
    process.chdir('./projects/'+req.params.id);
    await cp.exec('flutter build apk');
    if (fs.existsSync('./build/app/outputs/flutter-apk/app-release.apk')){
        res.sendFile('/build/app/outputs/flutter-apk/app-release.apk');
    }else {
        res.send('Error');
    }
});

app.get('/home', async (req, res) => {
    try {
        let projects = await pool.request().query('SELECT * from Projects');
        console.log(user);
        res.render('home', {
            projects: projects.recordsets[0],
            user: user
        });
    }catch(err) {
        console.log(err);
        res.redirect('/');
    }
});

app.get('/auth/google', 
  passport.authenticate('google', { scope : ['profile', 'email'] }));
 
app.get('/auth/google/callback', 
  passport.authenticate('google', { failureRedirect: '/error' }),
  (req, res) => {
    // Successful authentication, redirect success.
    res.redirect('/home');
});
// Set up static file serving for 'upload' folder
const uploadsPath = path.join(__dirname, 'upload');
app.use('/upload', express.static(uploadsPath));

app.post('/project', async (req, res) => {
    let results = await pool.request()
    .input('ProjectName', sql.NVarChar, req.body['ProjectName'])
    .input('AppName', sql.NVarChar, req.body['AppName'])
    .input('PackageName', sql.NVarChar, req.body['PackageName'])
    .output('ProjectId', sql.Int)
    .query('INSERT INTO Projects(ProjectName, AppName, PackageName) VALUES(@ProjectName, @AppName, @PackageName);SELECT @ProjectId=SCOPE_IDENTITY()');
    

    fs.cpSync('./FleetStack', './projects/' + results.output.ProjectId, {recursive: true});


    res.redirect('/home');
})

//Temporary use
app.get('/drop', async ( req, res) => {
    await pool.request()
    .query('DROP TABLE Projects');
    res.send('Done');
})
app.get('/create', async(req, res) => {
    await pool.request()
    .query("CREATE TABLE Projects(UserId INT, ProjectId INT IDENTITY(1, 1)  PRIMARY KEY, ProjectName VARCHAR(255) NOT NULL, AppName VARCHAR(255) NOT NULL, PackageName VARCHAR(255) NOT NULL, ServerLogo VARCHAR(255), Icon VARCHAR(255), ServerURL VARCHAR(255) DEFAULT 'http://app.fleetstack.in/')");
    res.send('Done');
})

//end
app.get('/project/delete/:id', async(req, res) => {
    let results = await pool.request()
    .input('ProjectId', req.params.id)
    .query('DELETE FROM Projects WHERE ProjectId=@ProjectId')
    fs.rmSync('./projects/'+req.params.id, {recursive: true});
    res.redirect('/home');
});
app.get('/project/edit/:id', async(req, res) => {
    let project = await pool.request()
    .input('ProjectId', req.params.id)
    .query('SELECT * FROM Projects WHERE ProjectId=@ProjectId');
    console.log('editdd');
    console.log(project);
    res.render('build', {
        project: project.recordset[0],
        user: user
    });
});
app.get('/project', async (req, res) => {
    try {
        let projects = await pool.request()
        .input('UserId', user.UserId)
        .query('SELECT * from Projects WHERE UserId=@UserId');
        return projects.recordsets;
    }catch(err) {
        console.log(err);
    }
})
app.get('/logout', (req, res, next) => {
    req.session.destroy((e) => {
        req.logout((err) => {
            res.redirect('/')
        });
        
    })
})
app.get("/", async (req, res) => {
    pool = await sql.connect({
        server: '3.111.67.76',
        port: 1434,
        database: 'Fleetstack_Management',
        user: 'fstack',
        password: 'q!aloka5$PZ#9@vLm2',
        options: {
            encrypt: false
        }
    });

    res.sendFile(path.join(__dirname, 'views', 'login.html'));

            
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
    { name: 'applogo', maxCount: 1 },
]);

// Route to handle file upload
/**
 * @route POST /fileupload
 * @description Handle file upload.
 * @returns {void}
 * @throws {Error} If an invalid field name is provided.
 */
app.post('/project/change/:id', cpUpload, async (req, res) => {
    // console.log(req);

    process.chdir('./projects/'+req.params.id);
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
    const xmlData= fs.readFileSync('./android/app/src/main/AndroidManifest.xml', {encoding: 'utf8', flag: 'r'});
    const xmloptions = { ignoreAttributes: false, attributeNamePrefix: "@_"};
    const parser = new XMLParser(xmloptions);
    let jObj = parser.parse(xmlData);
    jObj['manifest']['application']['@_android:label'] = req.body['appname'];
    console.log(jObj);
    const builder = new XMLBuilder(xmloptions);
    fs.writeFileSync('./android/app/src/main/AndroidManifest.xml', builder.build(jObj));
    console.log('AndroidManifest.xml changed');

    //googleservice.json change

    const jsonData = fs.readFileSync('./android/app/google-services.json', {encoding: 'utf8', flag: 'r'});
    jObj = JSON.parse(jsonData);
    jObj['client'][0]['client_info']['android_client_info']['package_name'] = req.body['packagename']
    fs.writeFileSync('./android/app/google-services.json', JSON.stringify(jObj));
    console.log('google-services.json file changed');

    //serverurl change
    req.body['serverurl'];
    var commonDart = fs.readFileSync('./lib/common/FleetStack.dart', {encoding: 'utf8', flag: 'r'});

    var lines = commonDart.split("\n");
    lines[14] = `static final url=${req.body['serverurl']};`;
    fs.writeFileSync('./lib/common/FleetStack.dart', lines.join("\n"));
    console.log('serverurl changed');
    try {
        await pool.request()
        .input('AppName', req.body['appname'])
        .input('PackageName', req.body['packagename'])
        .input('ServerURL', req.body['serverurl'])
        .input('ProjectId', req.params.id)
        .query('UPDATE Projects SET AppName=@AppName PackageName=@PackageName ServerURL=@ServerURL WHERE ProjectId=@ProjectId');
        res.redirect('/home')
    }catch(err){
        console.log(err);

    }
    //flutter build 
    cp.exec('flutter build appbundle');
    console.log('flutter build appbundle finished');
    cp.exec('flutter build apk --debug');
    console.log('flutter build apk debug finished');
    // res.redirect('/projects/temp/build/app/outputs/bundle/release/app-release.aab');
    // res.redirect();
    res.sendFile('app-debug.apk', {root: path.join(__dirname, 'projects', 'temp', 'build', 'app', 'outputs', 'flutter-apk')});
});

// Start the server
/**
 * @description Start the server and listen on port 3001.
 * @event
 */
app.listen(3000, () => {
    console.log('server is running on port http://localhost:3000');
});
module.exports = {

  build_dir: 'build',
  compile_dir: 'bin',

  app_files: {
    js: [ 'src/**/*.js', '!src/**/*.spec.js', '!**/ajax/**' ],
    jsunit: [ 'src/**/*.spec.js', '!**/ajax/**' ],
    
    coffee: [ 'src/**/*.coffee', '!src/**/*.spec.coffee', '!src/ajax/**/*' ],
    coffeeunit: [ 'src/**/*.spec.coffee', '!src/ajax/**/*' ],

    atpl: [ 'src/app/**/*.html' ],
    ctpl: [ 'src/common/**/*.tpl.html' ],

    html: [ 'src/index.html' ],
    less: 'src/less/main.less',
		
    jade: [ 'src/**/*.jade' ]
  },

  vendor_files: {
    js: [
      'vendor/jquery/jquery.js',
      'vendor/jquery-ui/ui/jquery-ui.js',
      'vendor/fullcalendar/fullcalendar.js',
      'vendor/fullcalendar/gcal.js',
      'vendor/select2/select2.js',
      'vendor/angular/angular.js',
      'vendor/angular-pl/angular-locale_pl-pl.js',
      'vendor/meny/js/meny.js',
      'vendor/underscore/underscore-min.js',
      'vendor/underscore.string/dist/underscore.string.min.js',
      'vendor/angular-bootstrap/ui-bootstrap-tpls.min.js',
      'vendor/angular-ui-calendar/src/calendar.js',
      'vendor/angular-ui-router/release/angular-ui-router.js'
    ],
    css: [
      'vendor/fullcalendar/fullcalendar.css',
      'vendor/meny/css/demo.css',
    ]
  }
};

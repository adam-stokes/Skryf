gulp = require("gulp")
stylus = require("gulp-stylus")
uglify = require("gulp-uglify")
concat = require("gulp-concat")
nodemon = require("gulp-nodemon")
gulp.task "styles", ->
  gulp.src("style/**")
  .pipe(stylus(compress: true))
  .pipe gulp.dest("../public/css/")
  return

vendorCSS = ["bower_components/semantic/build/packaged/css/semantic.min.css"]
vendorScripts = [
  "bower_components/jquery/dist/jquery.min.js"
  "bower_components/semantic/build/packaged/javascript/semantic.min.js"
]

appScripts = [
    'static/js/app.js'
]

gulp.task "concatCSS", ->
  gulp.src(vendorCSS)
  .pipe(concat("vendor.min.css"))
  .pipe gulp.dest("../public/css/")
  return

gulp.task "concatJS", ->
  gulp.src(vendorScripts)
    .pipe(uglify())
    .pipe(concat("vendor.min.js"))
    .pipe gulp.dest("../public/js/")
    gulp.src(appScripts)
      .pipe(uglify())
      .pipe(concat("app.min.js"))
      .pipe gulp.dest("../public/js/")
  return

gulp.task "copyFonts", ->
  gulp.src 'bower_components/semantic/build/packaged/fonts/*'
    .pipe gulp.dest '../public/fonts'
gulp.task "copyImages", ->
  gulp.src 'bower_components/semantic/build/packaged/images/*'
    .pipe gulp.dest '../public/images'

  return

gulp.task "default", [
  "styles"
  "concatCSS"
  "concatJS"
  "copyFonts"
  "copyImages"
]

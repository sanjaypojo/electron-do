gulp = require "gulp"
browserify = require "browserify"
gulp = require "gulp"
plugins = require("gulp-load-plugins")()
sourceStream = require "vinyl-source-stream"
coffeeReactify = require "coffee-reactify"
envify = require "envify"

gulpError = (err) ->
  console.log err
  plugins.util.beep()
  @emit "done"

# Paths
paths =
  app:
    root: "app/"
    images: "app/images/"
  less: "src/style.less"
  jade: "src/index.jade"
  cjsx: "src/app.cjsx"

gulp.task "clean", () ->
  gulp.src paths.test.root, read: false
    .pipe plugins.clean()

gulp.task "jade", () ->
  gulp.src paths.jade
    .pipe plugins.plumber(errorHandler: gulpError)
    .pipe plugins.jade()
    .on "error", plugins.util.log
    .pipe gulp.dest paths.app.root

gulp.task "less", () ->
  gulp.src paths.less
    .pipe plugins.plumber(errorHandler: gulpError)
    .pipe plugins.less()
    .on "error", plugins.util.log
    .pipe gulp.dest paths.app.root

gulp.task "images", () ->
  return gulp.src paths.images
    .pipe plugins.plumber(errorHandler: gulpError)
    .pipe plugins.imagemin()
    .pipe gulp.dest paths.app.images

gulp.task "cjsx", () ->
  b = browserify {
    entries: paths.cjsx
    transform: [coffeeReactify, envify]
  }
  b.bundle()
    .on "end", () -> console.log "CJSX ready!"
    .pipe sourceStream "bundle.js"
    .pipe gulp.dest paths.app.root

gulp.task "watch", () ->
  gulp.watch paths.jade, ["jade"]
  gulp.watch paths.less, ["less"]
  gulp.watch paths.images, ["images"]
  gulp.watch paths.cjsx, ["cjsx"]

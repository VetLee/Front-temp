'use strict'

gulp = require('gulp')
watch = require('gulp-watch')
prefixer = require('gulp-autoprefixer')
uglify = require('gulp-uglify')
slim = require('gulp-slim')
coffee = require('gulp-coffee')
sass = require('gulp-sass')
sourcemaps = require('gulp-sourcemaps')
rigger = require('gulp-rigger')
cssmin = require('gulp-clean-css')
imagemin = require('gulp-imagemin')
pngquant = require('imagemin-pngquant')
rimraf = require('rimraf')
browserSync = require('browser-sync')
reload = browserSync.reload

path =
  build:
    html: 'build/'
    js: 'build/js/'
    css: 'build/css/'
    img: 'build/img/'
    fonts: 'build/fonts/'
  src:
    html: 'src/views/pages/*.slim'
    js: 'src/js/main.js'
    style: 'src/styles/main.sass'
    img: 'src/img/**/*.*'
    fonts: 'src/fonts/**/*.*'
  watch:
    html: 'src/views/**/*.slim'
    js: 'src/js/**/*.js'
    style: 'src/styles/**/*.sass'
    img: 'src/img/**/*.*'
    fonts: 'src/fonts/**/*.*'
  clean: './build'

config =
  server: baseDir: './build'
  tunnel: true
  host: 'localhost'
  port: 3333
  logPrefix: 'Front-temp'

gulp.task 'webserver', ->
  browserSync config
  return

gulp.task 'clean', (cb) ->
  rimraf path.clean, cb
  return

gulp.task 'html:build', ->
  gulp.src(path.src.html)
    .pipe(rigger())
    .pipe slim pretty: true
    .pipe(gulp.dest(path.build.html))
    .pipe reload(stream: true)
  return

gulp.task 'js:build', ->
  gulp.src(path.src.js)
    .pipe(rigger())
    .pipe(sourcemaps.init())
    .pipe(uglify())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest(path.build.js))
    .pipe reload(stream: true)
  return

gulp.task 'style:build', ->
  gulp.src(path.src.style)
    .pipe(rigger())  
    .pipe(sourcemaps.init())
    .pipe(sass(
      includePaths: [ 'src/styles/' ]
      outputStyle: 'compressed'
      sourceMap: true
      errLogToConsole: true))
    .pipe(prefixer())
    .pipe(cssmin())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest(path.build.css))
    .pipe reload(stream: true)
  return

gulp.task 'image:build', ->
  gulp.src(path.src.img)
    .pipe(imagemin(
      progressive: true
      svgoPlugins: [ { removeViewBox: false } ]
      use: [ pngquant() ]
      interlaced: true))
    .pipe(gulp.dest(path.build.img))
    .pipe reload(stream: true)
  return

gulp.task 'fonts:build', ->
  gulp.src(path.src.fonts)
    .pipe gulp.dest(path.build.fonts)
  return

gulp.task 'build', [
  'html:build'
  'js:build'
  'style:build'
  'fonts:build'
  'image:build'
]

gulp.task 'watch', ->
  watch [ path.watch.html ], (event, cb) ->
    gulp.start 'html:build'
    return
  watch [ path.watch.style ], (event, cb) ->
    gulp.start 'style:build'
    return
  watch [ path.watch.js ], (event, cb) ->
    gulp.start 'js:build'
    return
  watch [ path.watch.img ], (event, cb) ->
    gulp.start 'image:build'
    return
  watch [ path.watch.fonts ], (event, cb) ->
    gulp.start 'fonts:build'
    return
  return

gulp.task 'default', [
  'build'
  'webserver'
  'watch'
]

'use strict'

gulp = require('gulp')
watch = require('gulp-watch')
prefixer = require('gulp-autoprefixer')
sass = require('gulp-sass')
rigger = require('gulp-rigger')
slim = require('gulp-slim')
browserSync = require('browser-sync')
reload = browserSync.reload

path =
  build:
    html:   'build/'
    js:     'build/js/'
    css:    'build/css/'
    img:    'build/img/'
    fonts:  'build/fonts/'
  src:
    slim:   'src/*.slim'
    js:     'src/js/main.js'
    style:  'src/styles/main.sass'
    img:    'src/img/**/*.*'
    fonts:  'src/fonts/**/*.*'
  watch:
    slim:   'src/*.slim'
    js:     'src/js/**/*.js'
    style:  'src/styles/**/**/*.sass'
    img:    'src/img/**/*.*'
    fonts:  'src/fonts/**/*.*'

config =
  server: baseDir: './build'
  tunnel: true
  host: 'localhost'
  port: 3333
  logPrefix: 'Gulp_log'

gulp.task 'html:build', ->
  gulp.src(path.src.slim)
    .pipe(rigger())
    .pipe(slim(pretty: true))
    .pipe(gulp.dest(path.build.html))
    .pipe reload(stream: true)

gulp.task 'style:build', ->
  gulp.src(path.src.style)
    .pipe(sass())
    .pipe(prefixer())
    .pipe(gulp.dest(path.build.css))
    .pipe reload(stream: true)

gulp.task 'js:build', ->
  gulp.src(path.src.js)
    .pipe(rigger())
    .pipe(gulp.dest(path.build.js))
    .pipe reload(stream: true)

gulp.task 'image:build', ->
  gulp.src(path.src.img)
    .pipe(gulp.dest(path.build.img))
    .pipe reload(stream: true)

gulp.task 'build', [
  'html:build'
  'style:build'
  'js:build'
  'image:build'
]

gulp.task 'watch', ->
  watch [ path.watch.slim ], (event, cb) ->
    gulp.start 'html:build'
  watch [ path.watch.style ], (event, cb) ->
    gulp.start 'style:build'
  watch [ path.watch.js ], (event, cb) ->
    gulp.start 'js:build'

gulp.task 'webserver', ->
  browserSync config

gulp.task 'default', [
  'build'
  'webserver'
  'watch'
]

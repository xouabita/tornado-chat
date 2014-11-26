gulp    = require "gulp"
compass = require "gulp-compass"
coffee  = require "gulp-coffee"
concat  = require "gulp-concat"

gulp.task "compass", ->
    gulp.src './sass/**/*.sass'
    .pipe compass( css: "./styles", sass: './sass')
    .pipe gulp.dest("./styles")

gulp.task "coffee", ->
    gulp.src './coffee/**/*.coffee'
    .pipe coffee()
    .pipe concat('app.js')
    .pipe gulp.dest('scripts')

gulp.task "build", ["compass", "coffee"]


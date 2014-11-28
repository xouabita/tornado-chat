gulp    = require "gulp"
compass = require "gulp-compass"
coffee  = require "gulp-coffee"
concat  = require "gulp-concat"
shell   = require "gulp-shell"

gulp.task "compass", ->
    gulp.src './sass/**/*.sass'
    .pipe compass( css: "./styles", sass: './sass')
    .on 'error', (error) ->
        console.log error.toString()
        @emit 'end'
    .pipe gulp.dest("./styles")

gulp.task "coffee", ->
    gulp.src './coffee/**/*.coffee'
    .pipe coffee()
    .on 'error', (error) ->
        console.log error.toString()
        @emit 'end'
    .pipe concat('app.js')
    .pipe gulp.dest('scripts')

gulp.task "watch", ->
    gulp.watch './sass/**/*.sass', ['compass']
    gulp.watch './coffee/**/*.coffee', ['coffee']

gulp.task "build", ["compass", "coffee"]

gulp.task "runserver", ['build'], ->
    gulp.src '', read: no
    .pipe shell """
        python app.py
    """

gulp.task "serve", ["runserver", "watch"]

gulp.task "default", ["serve"]

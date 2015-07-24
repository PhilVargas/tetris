gulp = require 'gulp'
gulpTasks = require './gulp/tetris'

gulp.task('build', gulpTasks.build)
gulp.task('watch', gulpTasks.watch)
gulp.task('sass', gulpTasks.sass)

gulp = require 'gulp'
gulpTasks = require './gulp/tetris'

gulp.task('build:js', gulpTasks.build)
gulp.task('watch:js', gulpTasks.watch)
gulp.task('build:sass', gulpTasks.buildSass)
gulp.task('watch:sass', gulpTasks.watchSass)
gulp.task('assets:watch', ['watch:js','watch:sass'])

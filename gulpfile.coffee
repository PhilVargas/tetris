gulp = require 'gulp'
gulpTasks = require './gulp/tetris'

gulp.task('build:js', gulpTasks.build)
gulp.task('watch:js', gulpTasks.watch)
gulp.task('build:sass', gulpTasks.buildSass)
gulp.task('watch:sass', gulpTasks.watchSass)
gulp.task('build:assets', ['build:js','build:sass'])
gulp.task('watch:assets', ['watch:js','watch:sass'])

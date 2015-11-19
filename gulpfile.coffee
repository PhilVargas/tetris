gulp = require 'gulp'
gulpTasks = require './gulp/tetris'

gulp.task('js:build', gulpTasks.build)
gulp.task('js:watch', gulpTasks.watch)
gulp.task('build:js', gulpTasks.build)
gulp.task('watch:js', gulpTasks.watch)

gulp.task('sass:build', gulpTasks.buildSass)
gulp.task('sass:watch', gulpTasks.watchSass)
gulp.task('build:sass', gulpTasks.buildSass)
gulp.task('watch:sass', gulpTasks.watchSass)

gulp.task('assets:build', ['build:js','build:sass'])
gulp.task('assets:watch', ['watch:js','watch:sass'])
gulp.task('build:assets', ['build:js','build:sass'])
gulp.task('watch:assets', ['watch:js','watch:sass'])

gulp.task('deploy:clean', gulpTasks.deploy.clean)
gulp.task('deploy:build', gulpTasks.deploy.prep)
gulp.task('deploy:prep', ['deploy:clean'], gulpTasks.deploy.prep)
gulp.task('deploy', ['deploy:prep'], gulpTasks.deploy.prod)

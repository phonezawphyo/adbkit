path = require 'path'

module.exports = (grunt) ->

  grunt.initConfig
    pkg: require './package'
    coffee:
      src:
        options:
          bare: true
          noHeader: true
        expand: true
        cwd: 'src'
        src: '**/*.coffee'
        dest: 'lib'
        ext: '.js'
      index:
        src: 'index.coffee'
        dest: 'index.js'
    clean:
      lib:
        src: 'lib'
      index:
        src: 'index.js'
    coffeelint:
      options:
        indentation:
          level: 'ignore'
        no_backticks:
          level: 'ignore'
      src:
        src: '<%= coffee.src.cwd %>/<%= coffee.src.src %>'
      index:
        src: '<%= coffee.index.src %>'
      test:
        src: 'test/**/*.coffee'
      tasks:
        src: 'tasks/**/*.coffee'
      gruntfile:
        src: 'Gruntfile.coffee'
    jsonlint:
      packagejson:
        src: 'package.json'
    watch:
      src:
        files: '<%= coffee.src.cwd %>/<%= coffee.src.src %>'
        tasks: ['coffeelint:src', 'test']
      index:
        files: '<%= coffee.index.src %>'
        tasks: ['coffeelint:index', 'test']
      test:
        files: '<%= coffeelint.test.src %>',
        tasks: ['coffeelint:test', 'test']
      gruntfile:
        files: '<%= coffeelint.gruntfile.src %>'
        tasks: ['coffeelint:gruntfile']
      packagejson:
        files: '<%= jsonlint.packagejson.src %>'
        tasks: ['jsonlint:packagejson']
    exec:
      mocha:
        options: [
          '--compilers coffee:coffee-script/register'
          '--reporter spec'
          '--colors'
          '--recursive'
        ],
        cmd:
          path.relative('', 'node_modules/.bin/mocha') +
          ' <%= exec.mocha.options.join(" ") %>'
    keycode:
      generate:
        dest: 'src/adb/keycode.coffee'

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-jsonlint'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-notify'
  grunt.loadNpmTasks 'grunt-exec'
  grunt.loadTasks './tasks'

  grunt.registerTask 'test', ['jsonlint', 'coffeelint', 'exec:mocha']
  grunt.registerTask 'build', ['coffee']
  grunt.registerTask 'default', ['test']

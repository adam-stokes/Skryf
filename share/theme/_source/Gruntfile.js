module.exports = function(grunt) {

    // Project configuration.
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        browserify: {
            js: {
                files: {
                    '../public/js/app.js': ['js/app.js']
                }
            }
        },
        uglify: {
            build: {
                files: {
                    '../public/js/app-min.js': ['../public/javascripts/app.js']
                }
            }
        },
        stylus: {
            compile: {
                urlfunc: 'embedurl',
                options: {
                    compress: true
                },
                files: {
                    '../public/css/bundle.css': 'css/style.styl'
                }
            }
        }
    });

    // Default task(s).
    grunt.loadNpmTasks('grunt-browserify');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-stylus');
    grunt.registerTask('default', ['browserify',
        'stylus',
        'uglify'
    ]);

};

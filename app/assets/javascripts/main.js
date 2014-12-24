$(document).pjax('a', '[data-pjax-container]')
var routebeer = require('routebeer');
routebeer.init({
    routes   : {
        home : {
            pattern : '/',
            load    : function(params){ console.log('We on home'); },
            unload  : function(params){ console.log('We out home'); }
        },
        dashboard : {
            pattern : '/dashboard',
            load    : function(params){ console.log('We on dashboard'); },
            unload  : function(params){ console.log('We out dashboard'); }
        }
    },
    always   : function(route){ console.log('We ran something...'); },
    notFound : function(route){ console.log('Naw'); },
    event    : 'pjax:end'
});

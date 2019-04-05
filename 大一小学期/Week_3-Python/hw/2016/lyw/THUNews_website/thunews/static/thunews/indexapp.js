var app = angular.module('indexApp', []);

app.controller('IndexController', function(){
    this.keywords = "";
    this.redirect = function(){
        window.location.href = query_url + '/#/?keywords=' + this.keywords;
    };
});
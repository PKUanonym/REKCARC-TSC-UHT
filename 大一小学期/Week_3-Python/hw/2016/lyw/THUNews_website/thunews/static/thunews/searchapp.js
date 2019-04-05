var app = angular.module('searchApp', ['ngSanitize', 'ngRoute']);

app.controller('SearchController', ['$http', '$location', '$httpParamSerializer',
    function($http, $location, $httpParamSerializer){
        var searchController = this;
        this.result = {};
        this.keywords = $location.search().keywords;

        this.getDateLimit = function(){
            switch ($location.search().datelimit) {
                case "week":
                case "month":
                case "year":
                    return $location.search().datelimit;
                default:
                    return "";
            }
        };

        this.datelimit = this.getDateLimit();
        this.pageNum = $location.search().page || 1;

        this.callApi = function(){
            $http.get(query_url + '?' + $httpParamSerializer($location.search())).success(function(data){
                searchController.result = data;
            });
            window.scrollTo(0, 0);
        };

        this.search = function(){
            $location.search('keywords', this.keywords);
            $location.search('datelimit', this.datelimit);
            this.pageNum = 1;
            $location.search('page', 1);
            this.callApi();
        };

        this.prevPage = function(){
            --this.pageNum;
            $location.search('page', this.pageNum);
            this.callApi();
        };

        this.nextPage = function(){
            ++this.pageNum;
            $location.search('page', this.pageNum);
            this.callApi();
        };

        this.getPageStart = function(){
            return 10 * (this.pageNum - 1) + 1;
        };

        this.getPageEnd = function(){
            return Math.min(10 * this.pageNum, this.result.count);
        }

        this.callApi();

    }]
);
'use strict';

//http://chaijs.com/
var chai = require('chai');

//https://github.com/domenic/chai-as-promised/
var chaiAsPromised = require('chai-as-promised');
chai.use(chaiAsPromised);
var expect = chai.expect;

var BasicView = function () {
  browser.manage().timeouts().pageLoadTimeout(400000);
  browser.manage().timeouts().implicitlyWait(250000);
  browser.get('http://geoportalentst.lmv.lm.se:9080/geonetwork/srv/eng/catalog.search?view=swe#/home?');
  //browser.findElement(by.xpath("//*[contains(text(),'visa filtrering ')]")).click();
  browser.ignoreSynchronization = true;

  };

 BasicView.prototype = Object.create({}, {
   veiwFilter: {get: function(){

     return 	browser.findElement(by.xpath("//*[contains(text(),'visa filtrering ')]")).click();
   }},

	pageTitle: {get: function(){ return browser.getTitle(); }},

	basicCategoryList: {get: function(){
		return  element.all(by.repeater('topic in topicCategories | orderBy: orderByTranslated'));
	}},

	doFreeTextSearch: {get: function(){
		return browser.findElement(by.xpath("//*[@id='gn-any-field']")).sendKeys(protractor.Key.ENTER);
	}},

	typeSearchPhrase:{value: function(searchPhrase){
		return browser.findElement(by.xpath("//*[@id='gn-any-field']")).sendKeys(searchPhrase);
	}},

	clearFilter: {get: function(){
		return browser.findElement(by.xpath("//*[contains(text(),'Visa alla resurser')]")).click();
   }},


	clearFreetext:{get: function(){
		browser.findElement(by.xpath("//*[@id='gn-any-field']")).clear();
		//this.doFreeTextSearch;
	}},

	freeTextSearch: {value: function(searchPhrase){
		this.typeSearchPhrase(searchPhrase);
    browser.manage().timeouts().implicitlyWait(55000);
		this.doFreeTextSearch;
    browser.manage().timeouts().implicitlyWait(55000);

	}},

	selectCategory: {value: function(bc){
		this.basicCategoryList.then(function(category) {
			browser.manage().timeouts().implicitlyWait(55000);
			var i ;
			for ( i=0;i<category.length;i++) {
				var cat = category[i].element(by.css('.ng-scope .ng-binding'));
				cat.getText().then(function (actualCategory) {

					if (actualCategory == bc){
						element(by.partialLinkText(actualCategory)).click();
						console.log(bc + "Basic Category: " + actualCategory);
					}
				});
			}


        });



	}},
  resultList: {get: function(){
    		browser.manage().timeouts().implicitlyWait(55000);
		return element.all(by.repeater('md in searchResults.records'))
   }}


});

module.exports = BasicView;

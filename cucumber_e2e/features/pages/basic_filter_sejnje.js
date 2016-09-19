'use strict';

//http://chaijs.com/
var chai = require('chai');

//https://github.com/domenic/chai-as-promised/
var chaiAsPromised = require('chai-as-promised');
chai.use(chaiAsPromised);
var expect = chai.expect;

var BasicView = function () {
  browser.manage().timeouts().pageLoadTimeout(40000);
  browser.manage().timeouts().implicitlyWait(25000);
  browser.get('http://geoportalentst.lmv.lm.se:9080/geonetwork/srv/eng/catalog.search?view=swe#/home?');
  browser.ignoreSynchronization = true;

  };

 BasicView.prototype = Object.create({}, {
   veiwFilter: {get: function(){

     return 	Element(by.xpath("//*[contains(text(),'visa filtrering ')]")).click();
     //return 	browser.findElement(by.xpath("//*[contains(text(),'visa filtrering ')]")).click();
   }},

	 pageTitle: {get: function(){ return browser.getTitle(); }},

	basicCategoryList: {get: function(){
		return  Element.all(by.repeater('topic in topicCategories | orderBy: orderByTranslated'));
	}},

	doFreeTextSearch: {get: function(){
		Element(by.xpath("//*[@id='gn-any-field']")).sendKeys(protractor.Key.ENTER);
	}},

	typeSearchPhrase:{value: function(searchPhrase){
		return Element(by.xpath("//*[@id='gn-any-field']")).sendKeys(searchPhrase);
	}},

	freeTextSearch: {value: function(searchPhrase){
		this.typeSearchPhrase(searchPhrase);
    browser.manage().timeouts().implicitlyWait(55000);
		this.doFreeTextSearch;

	}},

	selectCategory: {value: function(bc){
		this.basicCategoryList.then(function(category) {
		//	browser.manage().timeouts().implicitlyWait(55000);
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
		return element.all(by.repeater('md in searchResults.records'));

	}},
  ViewMetadata: {get: function(){
    var f = this.resultList.first();
    f.element(by.css('.-label-link')).click()
	}}


});

module.exports = BasicView;

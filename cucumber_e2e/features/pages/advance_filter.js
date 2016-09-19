'use strict';

//http://chaijs.com/
var chai = require('chai');

//https://github.com/domenic/chai-as-promised/
var chaiAsPromised = require('chai-as-promised');
chai.use(chaiAsPromised);
var expect = chai.expect;

var AdvanceView = function () {
  browser.manage().timeouts().pageLoadTimeout(40000);
  browser.manage().timeouts().implicitlyWait(25000);
  browser.get('http://geoportalentst.lmv.lm.se:9080/geonetwork/srv/eng/catalog.search?view=swe#/home?');
  browser.ignoreSynchronization = true;

  };

 AdvanceView.prototype = Object.create({}, {


	 pageTitle: {get: function(){ return browser.getTitle(); }},

   veiwFilter: {get: function(){
     return 	browser.findElement(by.xpath("//*[contains(text(),'visa filtrering ')]")).click();
   }},	basicCategoryList: {get: function(){
   		return  element.all(by.repeater('topic in topicCategories | orderBy: orderByTranslated'));
   	}},

   	doFreeTextSearch: {get: function(){
   		return browser.findElement(by.xpath("//*[@id='gn-any-field']")).sendKeys(protractor.Key.ENTER);
   	}},

   	typeSearchPhrase:{value: function(searchPhrase){
   		return browser.findElement(by.xpath("//*[@id='gn-any-field']")).sendKeys(searchPhrase);
   	}},

   	freeTextSearch: {value: function(searchPhrase){
   		this.typeSearchPhrase(searchPhrase);
       browser.manage().timeouts().implicitlyWait(55000);
   		this.doFreeTextSearch;

   	}}


});

module.exports = AdvanceView;

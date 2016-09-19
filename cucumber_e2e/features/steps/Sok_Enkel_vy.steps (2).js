//http://chaijs.com/
var chai = require('chai');

//https://github.com/domenic/chai-as-promised/
var chaiAsPromised = require('chai-as-promised');
chai.use(chaiAsPromised);
var expect = chai.expect;

module.exports = function() {

	var AngularPage = require('../pages/basic_filter.js');
	page = new AngularPage(); 

	this.Given(/^that the user is in Enkel vy$/, function (callback) {
	
	page.pageTitle;
	
	expect(page.pageTitle).to.eventually.equal('Geodata.se - Lantmäteriet').and.notify(callback);
		
//	page.pageTitle.then(function (title) {console.log("Page title" + title);}); 

page.veiwFilter;
	
	});



	this.When(/^the user enters the text Testpost_fritext_titel_Geodatasamverkan in the fritext field$/, function (callback) {

	page.clearFilter;

	page.freeTextSearch('Testpost_fritext_titel_Geodatasamverkan');	
	
	callback(null);
        
    });
   
	this.Then(/^Testpost_fritext_titel_Geodatasamverkan is listed$/, function (callback) {
        
	var todoList = element.all(by.repeater('md in searchResults.records'));
	var titleElement = todoList.get(0).element(by.css('.ng-binding'));
	
	expect(titleElement.getText()).to.eventually.equal('Testpost_fritext_titel_Geodatasamverkan').and.notify(callback); 


//	callback();
//	callback(null);
	
	});



    this.When(/^the user enters the text Testpost_fritext_titel_Alternativtitel_Geodatasamverkan in the fritext field$/, function (callback) {

	page.clearFilter;
	
	page.freeTextSearch('Testpost_fritext_titel_Alternativtitel_Geodatasamverkan');	

	callback();	
//	callback(null);
	
    });

	
    this.Then(/^Testpost_fritext_titel_Alternativ_titel_Geodatasamverkan is listed$/, function (callback) {

	var todoList = element.all(by.repeater('md in searchResults.records'));
	var titleElement = todoList.get(0).element(by.css('.ng-binding'));
	
	expect(titleElement.getText()).to.eventually.equal('Testpost_fritext_titel_Alternativ_titel_Geodatasamverkan').and.notify(callback); 

		
//	callback();
//	callback(null);
	
    });

	   
	   
	this.When(/^the user enters the text Testpost_fritext_faalt_sammanfattning_Geodatasamverkan in the fritext field$/, function (callback) {
	
	page.clearFilter;
	
	page.freeTextSearch('Testpost_fritext_faalt_sammanfattning_Geodatasamverkan');	
	
//	callback();
//  callback(null);
	
    });
    
	this.Then(/^Testpost_fritext_faalt_samman_fattning_Geodatasamverkan is listed$/, function (callback) {
	var todoList = element.all(by.repeater('md in searchResults.records'));
	var titleElement = todoList.get(0).element(by.css('.ng-binding'));
	
	expect(titleElement.getText()).to.eventually.equal('Testpost_fritext_faalt_samman_fattning_Geodatasamverkan').and.notify(callback); 
	

//	callback();
//  callback(null);

    });
	 


    this.When(/^the user enters the text ""Testpost_fritext_titel_ett_ord_exakt_Geodatasamverkan"" in the fritext field$/, function (arg1, callback) {

    page.freeTextSearch('""Testpost_fritext_titel_ett_ord_exakt_Geodatasamverkan""');
         
    callback();
	
    });
	
	
    this.Then(/^""Testpost_fritext_titel_ett_ord_exakt_Geodatasamverkan"" is listed$/, function (arg1, callback) {
	var todoList = element.all(by.repeater('md in searchResults.records'));
	var titleElement = todoList.get(0).element(by.css('.ng-binding'));
	
	expect(titleElement.getText()).to.eventually.equal('""Testpost_fritext_titel_ett_ord_exakt_Geodatasamverkan""').and.notify(callback); 
	
//page.clearFilter;

    callback();
	
    });
	
	
    //this.When(/^the user enters the text "([^"]*)"Testpost_fritext_titel_tva_ord_exakt_Geodatasamverkan"([^"]*)" in the fritext field$/, function (arg1, arg2, callback) {
    this.When(/^the user enters the text "([^"]*)" in the fritext field$/, function (arg1, callback) {
 
	page.freeTextSearch('"Testpost_fritext_titel_tva_ord exakt_Geodatasamverkan"');
	
    callback();
	
    });
	
    this.Then(/^"([^"]*)" is listed$/, function (arg1, callback) {
    //this.Then(/^"([^"]*)"Testpost_fritext_titel_tva_ord_exakt_Geodatasamverkan is listed"([^"]*)"$/, function (arg1, arg2, callback) {
//	this.Then(/^"([^"]*)"$/, function (arg1, callback) {
    
	var todoList = element.all(by.repeater('md in searchResults.records'));
	var titleElement = todoList.get(0).element(by.css('.ng-binding'));
	
	expect(titleElement.getText()).to.eventually.equal('"Testpost_fritext_titel_tva_ord exakt_Geodatasamverkan" is listed').and.notify(callback); 

//page.clearFilter;

    callback();
	
    });
	

		
	this.When(/^the user select amne "([^"]*)"$/, function (arg1, callback) {
    
//	page.veiwFilter;

	//page.clearFilter;
	
	page.selectCategory(arg1);	
	
	callback();
	
    });


    this.Then(/^Testpost_Aamne_lista_Geodatasamverkan is listed$/, function (callback) {

	var todoList = element.all(by.repeater('md in searchResults.records'));
	var titleElement = todoList.get(0).element(by.css('.ng-binding'));
	
	expect(titleElement.getText()).to.eventually.equal('Testpost_aamne_lista_Geodatasamverkan is listed').and.notify(callback); 

	//page.clearFilter;

	callback();
	
    });
	
	
    this.When(/^the user combine amne "([^"]*)" with entering the text Testpost_aamne_lista_fritext_Geodatasamverkan in the fritext field$/, function (arg1, callback) {
    
//	page.veiwFilter;

	//page.clearFilter;
	
	page.selectCategory(arg1);	
	
	page.freeTextSearch('Testpost_aamne_lista_fritext_Geodatasamverkan');
	
	callback();
	     
    });

	this.Then(/^Testpost_Aamne_lista_fritext_Geodatasamverkan is listed$/, function (callback) {
    
	var todoList = element.all(by.repeater('md in searchResults.records'));
	var titleElement = todoList.get(0).element(by.css('.ng-binding'));
	
	expect(titleElement.getText()).to.eventually.equal('Testpost_aamne_lista_fritext_Geodatasamverkan is listed').and.notify(callback); 
  
	//page.clearFilter;

	callback();
	     
    });
	
}
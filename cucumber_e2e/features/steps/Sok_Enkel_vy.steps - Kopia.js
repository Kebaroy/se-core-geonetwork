//http://chaijs.com/
var chai = require('chai');

//https://github.com/domenic/chai-as-promised/
var chaiAsPromised = require('chai-as-promised');
chai.use(chaiAsPromised);
var expect = chai.expect;

module.exports = function() {

	this.Given(/^that the user is in Enkel vy$/, function (callback) {
    browser.manage().timeouts().pageLoadTimeout(40000);
    browser.manage().timeouts().implicitlyWait(25000);


	browser.get('http://geoportalentst.lmv.lm.se:9080/geonetwork/srv/eng/catalog.search?view=swe#/home?');
	browser.ignoreSynchronization = true;
	//browser.waitForAngular();
//	browser.findElement(by.xpath("//*[contains(text(),'börja använda geodataportalen')]")).click();
	
	browser.findElement(by.xpath("//*[contains(text(),'visa filtrering')]")).click();

//	browser.findElement(by.xpath("//*[contains(text(),'BIOTA')]")).click();

	
	//browser.pause();

//	expect(browser.getTitle()).to.eventually.equal('Geodata.se - Lantmäteriet').and.notify(callback);

    	browser.findElement(by.xpath("//*[@id='gn-any-field']")).sendKeys('TEST - Hydrografi Visning Inspire');
	
		browser.findElement(by.xpath("//*[@id='gn-any-field']")).sendKeys(protractor.Key.ENTER);
		browser.manage().timeouts().implicitlyWait(25000);
	
		var todoList = element.all(by.repeater('md in searchResults.records'));
		var titleElement = todoList.get(1).element(by.css('.ng-binding'));
		//console.log(titleElement.count);
		//browser.pause();
	
		expect(titleElement.getText()).to.eventually.equal('TEST - Hydrografi Visning Inspire').and.notify(callback); 

	
	
	
	//browser.findElement(by.xpath("//*[contains(text(),'visa filtrering')]")).click(); 	
	//browser.sleep();
	//browser.ignoreSynchronization = false;

	//browser.findElement(by.css('filter-toggle-link opens-filter-section')).click();
	//browser.findElement(by.xpath("//*[@id='gn-any-field']")).sendKeys('Afrika');
	
	//browser.pause();


	
  });

	this.When(/^the user enters the text Testpost_fritext_titel_Geodatasamverkan in the fritext field$/, function (callback) {
         // Write code here that turns the phrase above into concrete actions
//		browser.findElement(by.xpath("//*[@id='gn-any-field']")).sendKeys('TEST - Hydrografi Visning Inspire');
	
//		browser.findElement(by.xpath("//*[@id='gn-any-field']")).sendKeys(protractor.Key.ENTER);
//		browser.manage().timeouts().implicitlyWait(25000);
	
//		var todoList = element.all(by.repeater('md in searchResults.records'));
//		var titleElement = todoList.get(1).element(by.css('.ng-binding'));
		//console.log(titleElement.count);
		//browser.pause();
	
//		expect(titleElement.getText()).to.eventually.equal('TEST - Hydrografi Visning Inspire').and.notify(callback); 

		 
		 //         callback(null, 'pending');
  });


       this.Then(/^Testpost_fritext_titel_Geodatasamverkan is listed$/, function (callback) {
         // Write code here that turns the phrase above into concrete actions
		
		 
		 //         callback(null, 'pending');

  });
  
}

     
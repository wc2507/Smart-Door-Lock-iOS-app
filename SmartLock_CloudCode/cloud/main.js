
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});
Parse.Cloud.define("cal",function(request,response){
    var jssha = require('cloud/jssha256.js')
    var query = new Parse.Query("HAHA")
    query.equalTo("ID",request.params.ID)
	query.count({
	  success: function(count) {
		  if (count != 0){
		      query.find({
		          success: function(results){
		              var msg = results[0].get('Msg')
		              var key = results[0].get('key')
		              var msg2 = 'Hi how are you'
		              var key2 = 'hihihihddwdwdw'
		              var signiture1 = jssha.HMAC_SHA256_MAC(msg,key)
		              var signiture2 = jssha.HMAC_SHA256_MAC(msg2,key2)
		  				response.success(signiture1+' '+signiture2)
           
		          },
		          error: function(){
		              response.error("failed")
		          }
		      })

		  }else{
		  	
			response.success("lalalajshsidsidis")
			
		  }
	  },
	  error: function(error) {
	    // The request failed
	  }
  })
     
});

Parse.Cloud.define("Reg",function(request,response){
	var PIF = Parse.Object.extend("Product_Info");
	var Register = Parse.Object.extend("Register");
	var PIFQ = new Parse.Query(PIF);
	var RegQ = new Parse.Query(Register);
	var CUID = request.params.CUID;
	var PID = request.params.ID;
	var nKey = request.params.nKey;
	PIFQ.equalTo("ProductID",PID);
	RegQ.equalTo("UserID",CUID);
	RegQ.equalTo("ProductID",PID);
	PIFQ.first({
	  success: function(product) {
		  if(product === undefined){
		  	response.success("Invalid Product Key")
		  }else{
			  RegQ.count({
			    success: function(count) {
					if (count == 0){
						var Reg2Q = new Parse.Query(Register);
						Reg2Q.equalTo("UserID",CUID);
						Reg2Q.equalTo("nameOfKey",nKey);
		  			  Reg2Q.count({
		  			    success: function(count2) {
							if(count2 == 0){
								var newProduct = new Register ()
								newProduct.set("ProductID",PID);
								newProduct.set("UserID",CUID);
								newProduct.set("nameOfKey",nKey);
								newProduct.save(null, {
								  success: function(gameScore) {
								     response.success("Successfully registered" );
									 product.increment("timeOfUse");
									 product.save();
								  },
								  error: function(gameScore, error) {
								  }
								});
								
							}else{
								response.success("Please Use different Key name" );
								
							}
					    },
					    error: function(error) {
					      // The request failed
					    }
					  }); 
						
						

					}else{
						response.success("You have already registered the product" );
						
					}

			    },
			    error: function(error) {
			      // The request failed
			    }
			  }); 

	  }
	  },
	  error: function(error) {
	    alert("Error: " + error.code + " " + error.message);
	  }
	});
});

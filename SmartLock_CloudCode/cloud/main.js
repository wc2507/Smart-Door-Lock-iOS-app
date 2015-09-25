
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
var crypto = require('crypto');

function random (howMany, chars) {
    chars = chars 
        || "abcdefghijklmnopqrstuwxyzABCDEFGHIJKLMNOPQRSTUWXYZ0123456789";
    var rnd = crypto.randomBytes(howMany)
        , value = new Array(howMany)
        , len = chars.length;

    for (var i = 0; i < howMany; i++) {
        value[i] = chars[rnd[i] % len]
    };

    return value.join('');
}

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
	var NameQ = new Parse.Query(Parse.User);
	var PIF = Parse.Object.extend("Product_Info");
	var Register = Parse.Object.extend("Register");
	var PIFQ = new Parse.Query(PIF);
	var RegQ = new Parse.Query(Register);
	var CUID = request.params.CUID;
	var PID = request.params.ID;
	var nKey = request.params.nKey;
	var userName = ""
	PIFQ.equalTo("ProductID",PID);
	RegQ.equalTo("UserID",CUID);
	RegQ.equalTo("ProductID",PID);
	NameQ.get(CUID,{
		success: function(userq){
			userName = userq.get("Name");
		},
		error: function(object,error){
			
		}
	});
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
								newProduct.set("fixChallenge",product.get('Fixed_Challenge'));
								newProduct.set("UserName",userName);
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

Parse.Cloud.define("lockLog",function(request,response){
	var PID = new Parse.Query("Register");
	var LogQ = new Parse.Query("Lock_Log");
	var UPID = "";
	var message = [];
	var msg ="lalaal"
	PID.equalTo("UserID",request.params.CUID);
	PID.equalTo("nameOfKey",request.params.NK);
	PID.find({
		success: function(ID){
			UPID = ID[0].get("ProductID")
			LogQ.equalTo("PID",UPID);
			LogQ.descending("updatedAt");
			LogQ.find({
				success: function(results){
					for (var i = 0; i < results.length; i++){
						var ob = results[i]
						var time = new Date(ob.updatedAt)  
						var timediff = -4*60+time.getTimezoneOffset()
						var offsetTime = new Date(time.getTime() + timediff*60*1000)
					    var timeS = offsetTime.toString();
						 msg = ob.get("userName")+"/"+ob.get("Status")+"/"+timeS.split(" GMT")[0]
						message.push(msg)
					}
					response.success(message);
				},
				error: function(error){
					response.error("Error: " + error.code + " " + error.message);
				}
			})
		},
		error: function(error){
			response.error("no");
		}
	})
	
});

Parse.Cloud.define("unlock",function(request,response){
	var PID = new Parse.Query("Register");
	var Log = new Parse.Object.extend("Lock_Log");
	var jssha = require('cloud/jssha256.js')
	var fixcha = "";
	var UPID = "";
	var userName = "";
	PID.equalTo("UserID",request.params.CUID);
	PID.equalTo("nameOfKey",request.params.NK);
	PID.find({
		success: function(ID){
			UPID = ID[0].get("ProductID");
			fixcha = ID[0].get("fixChallenge");
			userName = ID[0].get("UserName");
			var RN = random(10)
		    var signiture1 = jssha.HMAC_SHA256_MAC(fixcha,RN)
			var newLog = new Log();
			newLog.set("PID",UPID);
			newLog.set("userName",userName);
			newLog.set("RM",RN);
			newLog.set("MAC",signiture1);
			newLog.set("Status","Attenpting...");
			newLog.save(null, {
			  success: function(success) {
				response.success(RN+" "+signiture1)
			  },
			  error: function(error) {
			  }
			});
        },
		error: function(error){
			
		}
	})

});

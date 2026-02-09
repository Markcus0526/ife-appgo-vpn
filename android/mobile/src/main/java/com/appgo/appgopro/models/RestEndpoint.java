package com.appgo.appgopro.models;

import java.util.List;

import retrofit2.Call;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.Path;
import retrofit2.http.Query;

/**
 * Created by KSMA on 4/19/2017.
 */

public interface RestEndpoint {
	@FormUrlEncoded
	@POST("/register")
	Call<AGRegister> register(@Field("mobile") String mobile,
                              @Field("nickname") String nickName,
                              @Field("password") String password,
                              @Field("email") String email,
                              @Field("verify_code") String verifyCode);

	@FormUrlEncoded
	@POST("/login")
	Call<AGLogin> login(@Field("username") String userName,
                        @Field("password") String password,
                        @Field("client_id") String clientId,
                        @Field("client_secret") String clientSecret,
                        @Field("grant_type") String grantType);

	@FormUrlEncoded
	@POST("/password")
	Call<AGPassword> password(@Field("mobile") String mobile,
                              @Field("new_password") String newPassword,
                              @Field("verify_code") String verifyCode);

	@FormUrlEncoded
	@POST("/sms")
	Call<AGSms> sms(@Field("for") String smsType,
                    @Field("mobile") String mobile);

//	@GET("/tourist/{platform}/{client_id}")
//	void touristId(@Path("platform") String platform,
//				   @Path("client_id") String clientId);

	@GET("/countries")
	Call<List<AGCountry>> countries();

	@GET("/country/{country_id}/packages")
	Call<List<AGPack>> countryPackage(@Path("country_id") int countryId);

	@GET("/user")
	Call<AGUserData> user();

	@GET("/user/services")
	Call<List<AGProfile>> userServices();

	@FormUrlEncoded
	@POST("/cart")
	Call<AGCart> cart(@Field("package_id") int packageId,
                      @Field("payment_method") String paymentMethod);


	@FormUrlEncoded
	@POST("/pay/validate/acoin")
	Call<AGValidateACoin> validateACoin(@Field("trade_no") String tradeNo,
                                        @Field("fee") float fee);

	@GET("/rules")
	Call<List<AGRule>> getAllRuleNames();

	@GET("/rule/{name}")
	Call<AGRule> getRule(@Path("name") String name);

	@GET("/rule/{name}/updated_at")
	Call<AGRuleUpdatedAt> getRuleUpdatedAt(@Path("name") String name);

	@GET("/notifications")
	Call<AGNotification> notifications(@Query("page") String page, @Query("per_page") String perPage);

	@GET("/aboutus")
	Call<AGAboutus> aboutus();

	@GET("/tos")
	Call<AGTos> tos();

	@GET("/switch/payment")
	Call<AGPayment> paySwitch();

	@GET("/app/version?platform=Android")
	Call<AGVersion> version();
}

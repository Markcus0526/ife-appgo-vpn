package com.appgo.appgopro.models

import com.google.gson.annotations.SerializedName


/**
 * Created by KSMA on 4/19/2017.
 */

class RestError private constructor() {

    inner class ApiError {
        @SerializedName("message")
        private var statusCode: Int = 0
        @SerializedName("errorMessage")
        private var message: String? = null

        constructor(message: String) {
            this.message = message
        }

        constructor(statusCode: Int, message: String) {
            this.statusCode = statusCode
            this.message = message
        }

        fun status(): Int {
            return statusCode
        }

        fun message(): String? {
            return message
        }

        fun setStatusCode(statusCode: Int) {
            this.statusCode = statusCode
        }
    }

    //	public static ApiError parseApiError(Response<?> response) {
    //		final Converter<ResponseBody, ApiError> converter =
    //				AppGoApplication.sharedInstance().getInstance().getRetrofit()
    //						.responseBodyConverter(ApiError.class, new Annotation[0]);
    //
    //		ApiError error;
    //		try {
    //			error = converter.convert(response.errorBody());
    //		} catch (IOException e) {
    //			error = new ApiError(0, "Unknown error"
    //		}
    //		return error;
    //	}
}

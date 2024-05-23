package com.bookshop01.selenium;

import java.io.Serializable;

import org.springframework.stereotype.Component;

@Component("seleniumVO")
public class SeleniumVO implements Serializable{
	
	public String youUrl;

	public String getYouUrl() {
		return youUrl;
	}

	public void setYouUrl(String youUrl) {
		this.youUrl = youUrl;
	}

	

}
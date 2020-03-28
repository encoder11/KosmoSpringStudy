package com.naver.erp;

public class ContactSearchDTO {
	private String keyword1;
	private String keyword2;
	private int selectPageNo=1;
	private int rowCntPerPage=10;
	private String[] readcnt;
	private String orAnd="or";
	private String[] searchSkills;
	private String front_year;
	private String front_month;
	private String back_year;
	private String back_month;
	private String zero="0";
	
	
	
	public String getZero() {
		return zero;
	}
	public void setZero(String zero) {
		this.zero = zero;
	}
	public String[] getSearchSkills() {
		return searchSkills;
	}
	public void setSearchSkills(String[] searchSkills) {
		this.searchSkills = searchSkills;
	}
	public String getFront_year() {
		return front_year;
	}
	public void setFront_year(String front_year) {
		this.front_year = front_year;
	}
	public String getFront_month() {
		return front_month;
	}
	public void setFront_month(String front_month) {
		this.front_month = front_month;
	}
	public String getBack_year() {
		return back_year;
	}
	public void setBack_year(String back_year) {
		this.back_year = back_year;
	}
	public String getBack_month() {
		return back_month;
	}
	public void setBack_month(String back_month) {
		this.back_month = back_month;
	}
	public String getOrAnd() {
		return orAnd;
	}
	public void setOrAnd(String orAnd) {
		this.orAnd = orAnd;
	}
	public String getKeyword2() {
		return keyword2;
	}
	public void setKeyword2(String keyword2) {
		this.keyword2 = keyword2;
	}
	public String getKeyword1() {
		return keyword1;
	}
	public void setKeyword1(String keyword1) {
		this.keyword1 = keyword1;
	}
	public int getSelectPageNo() {
		return selectPageNo;
	}
	public void setSelectPageNo(int selectPageNo) {
		this.selectPageNo = selectPageNo;
	}
	public int getRowCntPerPage() {
		return rowCntPerPage;
	}
	public void setRowCntPerPage(int rowCntPerPage) {
		this.rowCntPerPage = rowCntPerPage;
	}
	public String[] getReadcnt() {
		return readcnt;
	}
	public void setReadcnt(String[] readcnt) {
		this.readcnt = readcnt;
	}
	
	

}

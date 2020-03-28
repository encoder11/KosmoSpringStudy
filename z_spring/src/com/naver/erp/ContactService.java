package com.naver.erp;

import java.util.List;
import java.util.Map;

public interface ContactService {
	
	List<Map<String,String>> getcontactList(ContactSearchDTO contactSearchDTO);
	
	int getcontactListAllCnt(ContactSearchDTO contactSearchDTO);
	
	int insertContact(ContactDTO contactDTO);
	
	int goUpContact(ContactDTO contactDTO);

	int goDelContact(ContactDTO contactDTO);
}

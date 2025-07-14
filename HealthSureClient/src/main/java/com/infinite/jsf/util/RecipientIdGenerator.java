package com.infinite.jsf.util;

import org.hibernate.Session;

public class RecipientIdGenerator {

	    public static String getNextRecipientId(Session session) {
	        String prefix = "HID";
	        String hql = "select max(hId) from Recipient"; 
	        String maxId = (String) session.createQuery(hql).uniqueResult();

	        if (maxId == null) {
	            return prefix + "001";
	        }

	        int id = Integer.parseInt(maxId.substring(prefix.length()));
	        id++;
	        return String.format("%s%03d", prefix, id);
	    }
	}

package com.infinite.jsf.recipient.daoImpl;

import java.util.List;
import java.util.ArrayList;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Restrictions;

import com.infinite.jsf.provider.model.Doctors;
import com.infinite.jsf.recipient.dao.SearchDoctorDao;
import com.infinite.jsf.util.SessionHelper;

public class SearchDoctorDaoImpl implements SearchDoctorDao {

	private SessionFactory sessionFactory;

	public SearchDoctorDaoImpl() {
		this.sessionFactory = SessionHelper.getSessionFactory(); // You can inject if using DI
	}

	@Override
	public List<Doctors> searchDoctors(String searchBy, String value) {
		Session session = sessionFactory.openSession();
		Criteria criteria = session.createCriteria(Doctors.class, "doctor");

		if ("doctorName".equalsIgnoreCase(searchBy)) {
//        	Search anywhere within the string where the provided value exists
			criteria.add(Restrictions.ilike("doctorName", value, MatchMode.ANYWHERE));
		} else if ("specialization".equalsIgnoreCase(searchBy)) {
			criteria.add(Restrictions.ilike("specialization", "%" + value + "%"));
		} else if ("address".equalsIgnoreCase(searchBy)) {
			criteria.add(Restrictions.ilike("address", "%" + value + "%"));
		}

		List<Doctors> doctors = criteria.list();
		session.close();
		return doctors != null ? doctors : new ArrayList<>();
	}
}

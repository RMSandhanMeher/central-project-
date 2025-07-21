package com.infinite.jsf.recipient.daoImpl;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Restrictions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.infinite.jsf.provider.model.Doctors;
import com.infinite.jsf.recipient.dao.SearchDoctorDao;
import com.infinite.jsf.util.SessionHelper;

public class SearchDoctorDaoImpl implements SearchDoctorDao {

    private static final Logger LOGGER = LoggerFactory.getLogger(SearchDoctorDaoImpl.class);

    static SessionFactory sessionFactory;
    static {
        sessionFactory = SessionHelper.getSessionFactory();
    }

    // Private helper method to avoid repetition (Core Engine)
    private List<Doctors> searchByCriteria(String fieldName, String keywordOrValue, MatchMode matchMode) {
        List<Doctors> result = new ArrayList<>();
        Session session = null;

        try {
            session = sessionFactory.openSession();
            Criteria criteria = session.createCriteria(Doctors.class);

            if (matchMode != null) {
                criteria.add(Restrictions.ilike(fieldName, keywordOrValue.trim(), matchMode));
            } else {
                criteria.add(Restrictions.eq(fieldName, keywordOrValue));
            }

            result = criteria.list();
        } catch (Exception e) {
            LOGGER.error("Error searching doctors by field: {} with value: {}", fieldName, keywordOrValue, e);
        } finally {
            if (session != null) {
                session.close();
            }
        }

        return result != null ? result : new ArrayList<>();
    }

    // Drop Down based search from UI for Search Value
    @Override
    public List<Doctors> searchDoctors(String searchBy, String value) {
        try {
            if ("doctorName".equalsIgnoreCase(searchBy)) {
                return searchByCriteria("doctorName", value, MatchMode.ANYWHERE);
            } else if ("specialization".equalsIgnoreCase(searchBy)) {
                return searchByCriteria("specialization", value, null);
            } else if ("address".equalsIgnoreCase(searchBy)) {
                return searchByCriteria("address", value, MatchMode.ANYWHERE);
            }
        } catch (Exception e) {
            LOGGER.error("Error in searchDoctors with searchBy: {} and value: {}", searchBy, value, e);
        }
        return new ArrayList<>();
    }

    @Override
    public List<Doctors> findDoctorsByNameStartsWith(String keyword) {
        try {
            String searchKeyword = keyword.trim();
            if (!searchKeyword.toLowerCase().startsWith("dr.")) {
                searchKeyword = "Dr. " + searchKeyword;
            }
            return searchByCriteria("doctorName", searchKeyword, MatchMode.START);
        } catch (Exception e) {
            LOGGER.error("Error in findDoctorsByNameStartsWith with keyword: {}", keyword, e);
            return new ArrayList<>();
        }
    }

    @Override
    public List<Doctors> findDoctorsByNameContains(String keyword) {
        try {
            return searchByCriteria("doctorName", keyword, MatchMode.ANYWHERE);
        } catch (Exception e) {
            LOGGER.error("Error in findDoctorsByNameContains with keyword: {}", keyword, e);
            return new ArrayList<>();
        }
    }

    @Override
    public List<Doctors> findDoctorsByAddressStartsWith(String keyword) {
        try {
            return searchByCriteria("address", keyword, MatchMode.START);
        } catch (Exception e) {
            LOGGER.error("Error in findDoctorsByAddressStartsWith with keyword: {}", keyword, e);
            return new ArrayList<>();
        }
    }

    @Override
    public List<Doctors> findDoctorsByAddressContains(String keyword) {
        try {
            return searchByCriteria("address", keyword, MatchMode.ANYWHERE);
        } catch (Exception e) {
            LOGGER.error("Error in findDoctorsByAddressContains with keyword: {}", keyword, e);
            return new ArrayList<>();
        }
    }

    // Fetches all the distinct specialization
    @Override
    public List<String> fetchAllSpecialization() {
        Session session = null;
        List<String> specializations = new ArrayList<>();

        try {
            session = sessionFactory.openSession();
            Query query = session.getNamedQuery("fetchAllSpecializations");
            specializations = query.list();
        } catch (Exception e) {
            LOGGER.error("Error fetching all specializations", e);
        } finally {
            if (session != null) {
                session.close();
            }
        }

        return specializations != null ? specializations : new ArrayList<>();
    }
}
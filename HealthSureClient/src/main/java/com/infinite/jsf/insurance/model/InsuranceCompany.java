package com.infinite.jsf.insurance.model;

import java.io.Serializable;
import java.util.Set;

public class InsuranceCompany implements Serializable {
	private String companyId;
	private String name;
	private String logoUrl;
	private String headOffice;
	private String contactEmail;
	private String contactPhone;

	public String getCompanyId() {
		return companyId;
	}

	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getLogoUrl() {
		return logoUrl;
	}

	public void setLogoUrl(String logoUrl) {
		this.logoUrl = logoUrl;
	}

	public String getHeadOffice() {
		return headOffice;
	}

	public void setHeadOffice(String headOffice) {
		this.headOffice = headOffice;
	}

	public String getContactEmail() {
		return contactEmail;
	}

	public void setContactEmail(String contactEmail) {
		this.contactEmail = contactEmail;
	}

	public String getContactPhone() {
		return contactPhone;
	}

	public void setContactPhone(String contactPhone) {
		this.contactPhone = contactPhone;
	}

	public InsuranceCompany() {
		super();
	}

	public InsuranceCompany(String companyId, String name, String logoUrl, String headOffice, String contactEmail,
			String contactPhone) {
		super();
		this.companyId = companyId;
		this.name = name;
		this.logoUrl = logoUrl;
		this.headOffice = headOffice;
		this.contactEmail = contactEmail;
		this.contactPhone = contactPhone;
	}

	@Override
	public String toString() {
		return "InsuranceCompany [companyId=" + companyId + ", name=" + name + ", logoUrl=" + logoUrl + ", headOffice="
				+ headOffice + ", contactEmail=" + contactEmail + ", contactPhone=" + contactPhone + "]";
	}

}

package org.classes;

import java.util.Date;

public class Kisi {
    private String isim;
    private String soyad;
    private String tc;
    private String yas;
    private String il;
    private String ilce;
    private String telefon;
    private String aile;
    private String gelir;
    private String ihtiyac;
    private String adres;
    private String sonaciklama;
    private Date sontarih;

    public Kisi() {}

    public Kisi(String isim, String soyad, String tc, String yas, String il, String ilce, String telefon, String aile, String gelir, String ihtiyac, String adres, String sonaciklama, Date sontarih) {
        this.isim = isim;
        this.soyad = soyad;
        this.tc = tc;
        this.yas = yas;
        this.il = il;
        this.ilce = ilce;
        this.telefon = telefon;
        this.aile = aile;
        this.gelir = gelir;
        this.ihtiyac = ihtiyac;
        this.adres = adres;
        this.sonaciklama = sonaciklama;
        this.sontarih = sontarih;
    }

    public String getIsim() { return isim; }
    public void setIsim(String isim) { this.isim = isim; }
    public String getSoyad() { return soyad; }
    public void setSoyad(String soyad) { this.soyad = soyad; }
    public String getTc() { return tc; }
    public void setTc(String tc) { this.tc = tc; }
    public String getYas() { return yas; }
    public void setYas(String yas) { this.yas = yas; }
    public String getIl() { return il; }
    public void setIl(String il) { this.il = il; }
    public String getIlce() { return ilce; }
    public void setIlce(String ilce) { this.ilce = ilce; }
    public String getTelefon() { return telefon; }
    public void setTelefon(String telefon) { this.telefon = telefon; }
    public String getAile() { return aile; }
    public void setAile(String aile) { this.aile = aile; }
    public String getGelir() { return gelir; }
    public void setGelir(String gelir) { this.gelir = gelir; }
    public String getIhtiyac() { return ihtiyac; }
    public void setIhtiyac(String ihtiyac) { this.ihtiyac = ihtiyac; }
    public String getAdres() { return adres; }
    public void setAdres(String adres) { this.adres = adres; }
    public String getSonaciklama() { return sonaciklama; }
    public void setSonaciklama(String sonaciklama) { this.sonaciklama = sonaciklama; }
    public Date getSontarih() { return sontarih; }
    public void setSontarih(Date sontarih) { this.sontarih = sontarih; }
} 
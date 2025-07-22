package org.classes.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.classes.FirebaseService;
import org.springframework.beans.factory.annotation.Autowired;
import java.util.List;
import java.util.Map;
import org.springframework.web.bind.annotation.ResponseBody;
import org.classes.Kisi;

@Controller
public class AnaSayfaController {

    @Autowired
    private FirebaseService firebaseService;

    @GetMapping("/")
    public String anaSayfa(Model model) {
        List<String> bolgeler = firebaseService.getBolgeNames();
        model.addAttribute("bolgeler", bolgeler);
        return "index";  // src/main/resources/templates/index.html dosyasını yükler
    }

    @PostMapping("/secim")
    public String secimYapildi(@RequestParam String sehir,
                               @RequestParam String ilce,
                               Model model) {
        List<Kisi> kisiler = firebaseService.getKisilerByIlIlce(sehir, ilce);
        model.addAttribute("kisiler", kisiler);
        model.addAttribute("sehir", sehir);
        model.addAttribute("ilce", ilce);
        return "index";
    }

    @GetMapping("/ilceler")
    @ResponseBody
    public List<String> getIlceler(@RequestParam String bolge) {
        return firebaseService.getIlcelerForBolge(bolge);
    }

    @GetMapping("/person")
    public String personDetail() {
        return "person";
    }

    @GetMapping("/person/add")
    public String showPersonAddPage(Model model) {
        List<String> bolgeler = firebaseService.getBolgeNames();
        model.addAttribute("bolgeler", bolgeler);
        return "person_add";
    }

    @PostMapping("/person/add")
    public String addPerson(
        @RequestParam String isim,
        @RequestParam String soyad,
        @RequestParam String yas,
        @RequestParam String tc,
        @RequestParam String telefon,
        @RequestParam String aile,
        @RequestParam String gelir,
        @RequestParam String sehir, // il
        @RequestParam String ilce,
        @RequestParam String adres,
        @RequestParam String ihtiyac,
        Model model
    ) {
        Kisi yeniKisi = new Kisi();
        yeniKisi.setIsim(isim);
        yeniKisi.setSoyad(soyad);
        yeniKisi.setYas(yas);
        yeniKisi.setTc(tc);
        yeniKisi.setTelefon(telefon);
        yeniKisi.setAile(aile);
        yeniKisi.setGelir(gelir);
        yeniKisi.setIl(sehir);
        yeniKisi.setIlce(ilce);
        yeniKisi.setAdres(adres);
        yeniKisi.setIhtiyac(ihtiyac);
        yeniKisi.setSontarih(new java.util.Date());
        yeniKisi.setSonaciklama(ihtiyac);

        firebaseService.addKisiToIlIlce(yeniKisi, sehir, ilce);

        return "redirect:/";
    }
}

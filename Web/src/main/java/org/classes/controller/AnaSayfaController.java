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
        model.addAttribute("sehir", sehir);
        model.addAttribute("ilce", ilce);
        return "index";
    }

    @GetMapping("/ilceler")
    @ResponseBody
    public List<String> getIlceler(@RequestParam String bolge) {
        return firebaseService.getIlcelerForBolge(bolge);
    }
}

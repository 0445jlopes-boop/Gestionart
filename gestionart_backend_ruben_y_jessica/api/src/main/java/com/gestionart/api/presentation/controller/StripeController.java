package com.gestionart.api.presentation.controller;
import com.gestionart.api.application.service.StripeService;
import com.stripe.model.PaymentIntent;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api/stripe")
public class StripeController {

    private final StripeService service;

    public StripeController(StripeService service) {
        this.service = service;
    }

    @PostMapping("/crear-pago")
    public String crearPago() throws Exception {
        PaymentIntent intent = service.crearPago();
        return intent.getClientSecret(); // importante para frontend
    }
}